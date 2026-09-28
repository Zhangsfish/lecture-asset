"""Render a simple, opaque S00 TestFlight icon with no external assets."""

from pathlib import Path

from PIL import Image, ImageDraw


SIZE = 1024
SCALE = 2
output = Path(__file__).resolve().parents[1] / "App/Assets.xcassets/AppIcon.appiconset/AppIcon.png"

canvas = Image.new("RGB", (SIZE * SCALE, SIZE * SCALE))
pixels = canvas.load()
for y in range(SIZE * SCALE):
    for x in range(SIZE * SCALE):
        t = (x + y) / (4 * SIZE * SCALE)
        pixels[x, y] = (
            round(25 + 20 * t),
            round(81 + 56 * t),
            round(179 + 45 * t),
        )

draw = ImageDraw.Draw(canvas)


def box(bounds, radius, fill):
    draw.rounded_rectangle(tuple(round(v * SCALE) for v in bounds), radius * SCALE, fill=fill)


box((177, 273, 835, 687), 58, (199, 221, 255))
box((154, 247, 812, 661), 58, (224, 235, 255))
box((132, 225, 790, 639), 58, (255, 255, 255))
box((199, 288, 723, 576), 32, (38, 111, 204))
draw.ellipse((259 * SCALE, 344 * SCALE, 353 * SCALE, 438 * SCALE), fill=(255, 216, 116))
draw.polygon(
    [(263 * SCALE, 519 * SCALE), (396 * SCALE, 413 * SCALE),
     (487 * SCALE, 482 * SCALE), (557 * SCALE, 423 * SCALE),
     (660 * SCALE, 519 * SCALE)],
    fill=(239, 247, 255),
)

canvas.resize((SIZE, SIZE), Image.Resampling.LANCZOS).save(output, format="PNG", optimize=True)
print(f"Wrote opaque {SIZE}x{SIZE} app icon")
