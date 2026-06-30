/**
 * ANJAR AI — Cloudflare Worker v2
 * Handles: Claude AI brain + ElevenLabs TTS
 * Secrets needed: ANTHROPIC_API_KEY, ELEVENLABS_API_KEY, APP_TOKEN
 */

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, x-anjar-token',
};

export default {
  async fetch(request, env) {

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: CORS });
    }

    // Validate app token
    const token = request.headers.get('x-anjar-token');
    if (token !== env.APP_TOKEN) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...CORS, 'Content-Type': 'application/json' },
      });
    }

    const url = new URL(request.url);

    /* ── ElevenLabs TTS endpoint ── */
    if (url.pathname === '/tts') {
      const { text, voice_id = 'EXAVITQu4vr4xnSDxMaL', language_code } = await request.json();

      const elRes = await fetch(
        `https://api.elevenlabs.io/v1/text-to-speech/${voice_id}`,
        {
          method: 'POST',
          headers: {
            'xi-api-key': env.ELEVENLABS_API_KEY,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            text,
            model_id: 'eleven_multilingual_v2',
            voice_settings: {
              stability: 0.45,
              similarity_boost: 0.82,
              style: 0.15,
              use_speaker_boost: true,
            },
          }),
        }
      );

      if (!elRes.ok) {
        const err = await elRes.text();
        return new Response(JSON.stringify({ error: err }), {
          status: elRes.status,
          headers: { ...CORS, 'Content-Type': 'application/json' },
        });
      }

      const audio = await elRes.arrayBuffer();
      return new Response(audio, {
        headers: {
          ...CORS,
          'Content-Type': 'audio/mpeg',
          'Cache-Control': 'no-store',
        },
      });
    }

    /* ── Claude AI brain endpoint ── */
    const body = await request.json();

    const claudeRes = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': env.ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    const data = await claudeRes.json();
    return new Response(JSON.stringify(data), {
      headers: { ...CORS, 'Content-Type': 'application/json' },
    });
  },
};
