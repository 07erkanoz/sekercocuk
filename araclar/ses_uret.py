#!/usr/bin/env python3
"""Oyun sesleri ve müziği standart kütüphaneyle sentezler (44100 Hz, 16 bit, mono WAV)."""
import math, os, random, shutil, struct, subprocess, wave

SR = 44100
TEPE = 0.65  # en yüksek genlik (<%70)
KOK = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HEDEF = os.path.join(KOK, "oyun", "varliklar", "ses")


def hz(midi):
    return 440.0 * 2 ** ((midi - 69) / 12)


def ton(sure, f0, f1=None, dalga="sin", son=0.01, ilk=0.003, azal=3.0):
    """Frekansı f0'dan f1'e kayan, zarflı tek ses."""
    n = int(sure * SR)
    f1 = f0 if f1 is None else f1
    faz, out = 0.0, []
    for i in range(n):
        t = i / n
        faz += 2 * math.pi * (f0 + (f1 - f0) * t) / SR
        if dalga == "sin":
            v = math.sin(faz) + 0.25 * math.sin(2 * faz)
        elif dalga == "yumusak":  # üçgene yakın, tatlı
            v = (2 / math.pi) * math.asin(math.sin(faz))
        else:
            v = math.sin(faz)
        s = i / SR
        env = math.exp(-azal * t) * min(1.0, s / ilk, (n - i) / SR / son)
        out.append(v * env)
    return out


def karistir(parca, baslangic, uzunluk):
    buf = [0.0] * int(uzunluk * SR)
    for p, b in parca:
        o = int(b * SR)
        for i, v in enumerate(p):
            if o + i < len(buf):
                buf[o + i] += v
    return buf


def normalle(x, tepe=TEPE, giris=0.004, cikis=0.01):
    m = max(abs(v) for v in x) or 1.0
    k = tepe / m
    x = [v * k for v in x]
    g, c = int(giris * SR), int(cikis * SR)
    for i in range(min(g, len(x))):
        x[i] *= i / g
    for i in range(min(c, len(x))):
        x[-1 - i] *= i / c
    x[0] = 0.0
    x[-1] = 0.0
    return x


def yaz(ad, x):
    yol = os.path.join(HEDEF, ad + ".wav")
    with wave.open(yol, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, v)) * 32767)) for v in x))
    print("yazıldı", yol, "%.2f sn" % (len(x) / SR))


def zipla():
    return ton(0.2, 330, 760, azal=2.5, son=0.03)


def seker():
    a = ton(0.15, hz(88), azal=7, son=0.02)
    b = ton(0.15, hz(88) * 2, azal=10, son=0.02)
    return [u + 0.4 * v for u, v in zip(a, b)]


def hasar():
    return ton(0.3, 420, 170, dalga="yumusak", azal=2.2, son=0.06, ilk=0.01)


def bitis():
    nota = [(72, 0.0, 0.18), (76, 0.18, 0.18), (79, 0.36, 0.18), (84, 0.54, 0.3),
            (79, 0.84, 0.15), (84, 0.99, 0.5)]
    parca = [(ton(s + 0.1, hz(m), azal=2.5, son=0.05, dalga="yumusak"), b) for m, b, s in nota]
    parca += [(ton(0.5, hz(60), azal=3, son=0.05, dalga="yumusak"), 0.99),
              (ton(0.5, hz(67), azal=3, son=0.05, dalga="yumusak"), 0.99)]
    return karistir(parca, 0, 1.5)


def dugme():
    return ton(0.05, 900, 600, azal=5, son=0.01, ilk=0.001)


def kutu():
    """Sürpriz kutusuna kafa vurma: kısa, tok 'tok' ve üstüne küçük bir çın."""
    a = ton(0.09, 240, 150, dalga="yumusak", azal=6, son=0.02, ilk=0.001)
    b = ton(0.12, hz(84), azal=8, son=0.02)
    return karistir([(a, 0.0), ([v * 0.5 for v in b], 0.03)], 0, 0.16)


def yay():
    """Jöle yay: aşağıdan yukarı kayan, titreşimli 'boing'."""
    n = int(0.42 * SR)
    faz, out = 0.0, []
    for i in range(n):
        t = i / n
        f = 180 + 520 * t + 40 * math.sin(2 * math.pi * 18 * t * 0.42)
        faz += 2 * math.pi * f / SR
        out.append(math.sin(faz) * math.exp(-3.0 * t) * min(1.0, i / (0.004 * SR)))
    return out


def ezme():
    """Jöleyi ezme: yumuşak, aşağı inen 'şlop' ve iki notalık ödül sesi."""
    a = ton(0.12, 520, 160, dalga="yumusak", azal=4, son=0.03, ilk=0.002)
    b = ton(0.1, hz(83), azal=6, son=0.02)
    c = ton(0.14, hz(88), azal=6, son=0.03)
    return karistir([(a, 0.0), ([v * 0.6 for v in b], 0.08), ([v * 0.6 for v in c], 0.16)], 0, 0.32)


def kalp():
    """Can / gizli köşe: yukarı çıkan parlak arpej."""
    parca = [(ton(0.16, hz(m), azal=4, son=0.03, dalga="yumusak"), b)
             for m, b in [(76, 0.0), (79, 0.07), (84, 0.14), (88, 0.21)]]
    return karistir(parca, 0, 0.42)


def muzik():
    bpm = 120
    vurus = 60 / bpm
    bar = 4 * vurus
    akor = [(0, [60, 64, 67]), (5, [65, 69, 72]), (7, [67, 71, 74]), (0, [60, 64, 67])]  # C F G C
    gam = [60, 62, 64, 67, 69, 72, 69, 67, 64, 62]
    toplam = 12 * bar  # 24 sn
    rng = random.Random(7)
    parca = []
    for b in range(12):
        kok, notalar = akor[b % 4]
        t0 = b * bar
        # bas: kök nota, her vuruşta alt-üst
        bas = notalar[0] - 24
        for k in range(4):
            m = bas if k % 2 == 0 else bas + 7
            parca.append((ton(vurus * 0.9, hz(m), dalga="yumusak", azal=2.5, son=0.05), t0 + k * vurus))
        # akor arpej, 8'likler
        for k in range(8):
            m = notalar[k % 3] - 12
            parca.append((ton(vurus * 0.5, hz(m), dalga="yumusak", azal=4, son=0.04), t0 + k * vurus / 2))
        # melodi: akor tonlarından pentatonik çizgi
        for k in range(8):
            if b % 4 == 3 and k >= 6:
                continue
            ses = notalar[(k * 2 + b) % 3] + (12 if (k + b) % 3 else 0)
            if rng.random() < 0.3:
                ses = gam[(k + b) % len(gam)]
            parca.append((ton(vurus * 0.45, hz(ses), azal=3.5, son=0.04), t0 + k * vurus / 2))
    # son ölçü bitişini köke indir
    x = karistir(parca, 0, toplam)
    return normalle(x, giris=0.003, cikis=0.02)


def main():
    os.makedirs(HEDEF, exist_ok=True)
    for ad, f in [("zipla", zipla), ("seker", seker), ("hasar", hasar),
                  ("bitis", bitis), ("dugme", dugme), ("kutu", kutu), ("yay", yay),
                  ("ezme", ezme), ("kalp", kalp)]:
        yaz(ad, normalle(f()))
    yaz("muzik", muzik())
    if shutil.which("ffmpeg"):
        w = os.path.join(HEDEF, "muzik.wav")
        o = os.path.join(HEDEF, "muzik.ogg")
        r = subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", w, "-c:a", "libvorbis", "-q:a", "4", o])
        print("muzik.ogg", "üretildi" if r.returncode == 0 else "üretilemedi")
    elif shutil.which("oggenc"):
        subprocess.run(["oggenc", "-q", "4", "-o", os.path.join(HEDEF, "muzik.ogg"), os.path.join(HEDEF, "muzik.wav")])
    else:
        print("ffmpeg/oggenc yok: yalnız WAV üretildi")


if __name__ == "__main__":
    main()
