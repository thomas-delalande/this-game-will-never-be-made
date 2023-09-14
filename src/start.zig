const r = @cImport(@cInclude("raylib.h"));

pub fn setup() !void {
    r.InitWindow(800, 800, "Cool Game");
    r.SetTargetFPS(144);
    defer r.CloseWindow();

    const camera = r.Camera2D{
        .offset = r.Vector2{ .x = 0.0, .y = 0.0 },
        .target = r.Vector2{ .x = 0.0, .y = 0.0 },
        .rotation = 0.0,
        .zoom = 1.0,
    };
    _ = camera;
}
