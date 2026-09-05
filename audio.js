/**
 * Procedural Audio Synthesizer for Block Blaster
 * Uses Web Audio API without needing any external audio assets.
 */
class SoundManager {
    constructor() {
        this.ctx = null;
        this.muted = localStorage.getItem('blockBlaster_muted') === 'true';
        this.volume = parseFloat(localStorage.getItem('blockBlaster_volume') || '0.8');
    }

    init() {
        if (!this.ctx) {
            const AudioContext = window.AudioContext || window.webkitAudioContext;
            this.ctx = new AudioContext();
        }
        if (this.ctx.state === 'suspended') {
            this.ctx.resume();
        }
    }

    toggleMute() {
        this.muted = !this.muted;
        localStorage.setItem('blockBlaster_muted', this.muted);
        return this.muted;
    }

    setVolume(val) {
        this.volume = Math.max(0, Math.min(1, val));
        localStorage.setItem('blockBlaster_volume', this.volume);
    }

    getGain(baseGain) {
        return baseGain * (this.volume ?? 0.8);
    }

    playClick() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();

            osc.type = 'sine';
            osc.frequency.setValueAtTime(400, now);
            osc.frequency.exponentialRampToValueAtTime(800, now + 0.04);

            gain.gain.setValueAtTime(this.getGain(0.1), now);
            gain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);

            osc.connect(gain);
            gain.connect(this.ctx.destination);

            osc.start(now);
            osc.stop(now + 0.04);
        } catch (e) {}
    }

    playPickup() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();

            osc.type = 'sine';
            osc.frequency.setValueAtTime(320, now);
            osc.frequency.exponentialRampToValueAtTime(540, now + 0.08);

            gain.gain.setValueAtTime(this.getGain(0.15), now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.08);

            osc.connect(gain);
            gain.connect(this.ctx.destination);

            osc.start(now);
            osc.stop(now + 0.08);
        } catch (e) {}
    }

    playPlace() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();

            osc.type = 'triangle';
            osc.frequency.setValueAtTime(220, now);
            osc.frequency.exponentialRampToValueAtTime(110, now + 0.1);

            gain.gain.setValueAtTime(this.getGain(0.25), now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.1);

            osc.connect(gain);
            gain.connect(this.ctx.destination);

            osc.start(now);
            osc.stop(now + 0.1);
        } catch (e) {}
    }

    playClear(linesCount = 1, combo = 1) {
        if (this.muted) return;
        this.init();
        try {
            const baseFreqs = [523.25, 659.25, 783.99, 1046.50, 1318.51, 1567.98]; // C5, E5, G5, C6, E6, G6
            const count = Math.min(linesCount + combo, 6);

            for (let i = 0; i < count; i++) {
                const now = this.ctx.currentTime + (i * 0.06);
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();

                osc.type = 'sine';
                const freq = (baseFreqs[i % baseFreqs.length] || 1000) * (1 + (combo - 1) * 0.12);
                osc.frequency.setValueAtTime(freq, now);

                gain.gain.setValueAtTime(this.getGain(0.2), now);
                gain.gain.exponentialRampToValueAtTime(0.001, now + 0.25);

                osc.connect(gain);
                gain.connect(this.ctx.destination);

                osc.start(now);
                osc.stop(now + 0.25);
            }
        } catch (e) {}
    }

    playCoin() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();

            osc.type = 'sine';
            osc.frequency.setValueAtTime(987.77, now); // B5
            osc.frequency.setValueAtTime(1318.51, now + 0.08); // E6

            gain.gain.setValueAtTime(this.getGain(0.15), now);
            gain.gain.exponentialRampToValueAtTime(0.001, now + 0.3);

            osc.connect(gain);
            gain.connect(this.ctx.destination);

            osc.start(now);
            osc.stop(now + 0.3);
        } catch (e) {}
    }

    playPowerup() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();

            osc.type = 'sawtooth';
            osc.frequency.setValueAtTime(200, now);
            osc.frequency.exponentialRampToValueAtTime(800, now + 0.25);

            gain.gain.setValueAtTime(this.getGain(0.2), now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.25);

            osc.connect(gain);
            gain.connect(this.ctx.destination);

            osc.start(now);
            osc.stop(now + 0.25);
        } catch (e) {}
    }

    playExplosion() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();

            osc.type = 'sawtooth';
            osc.frequency.setValueAtTime(150, now);
            osc.frequency.exponentialRampToValueAtTime(40, now + 0.35);

            gain.gain.setValueAtTime(this.getGain(0.35), now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.35);

            osc.connect(gain);
            gain.connect(this.ctx.destination);

            osc.start(now);
            osc.stop(now + 0.35);
        } catch (e) {}
    }

    playLevelUp() {
        if (this.muted) return;
        this.init();
        try {
            const freqs = [440, 554.37, 659.25, 880];
            freqs.forEach((freq, idx) => {
                const now = this.ctx.currentTime + (idx * 0.08);
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();

                osc.type = 'triangle';
                osc.frequency.setValueAtTime(freq, now);

                gain.gain.setValueAtTime(this.getGain(0.25), now);
                gain.gain.exponentialRampToValueAtTime(0.001, now + 0.3);

                osc.connect(gain);
                gain.connect(this.ctx.destination);

                osc.start(now);
                osc.stop(now + 0.3);
            });
        } catch (e) {}
    }

    playGameOver() {
        if (this.muted) return;
        this.init();
        try {
            const now = this.ctx.currentTime;
            const freqs = [440, 392, 349, 293];
            freqs.forEach((freq, idx) => {
                const noteTime = now + (idx * 0.15);
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();

                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(freq, noteTime);

                gain.gain.setValueAtTime(this.getGain(0.18), noteTime);
                gain.gain.exponentialRampToValueAtTime(0.001, noteTime + 0.3);

                osc.connect(gain);
                gain.connect(this.ctx.destination);

                osc.start(noteTime);
                osc.stop(noteTime + 0.3);
            });
        } catch (e) {}
    }
}

window.soundManager = new SoundManager();
