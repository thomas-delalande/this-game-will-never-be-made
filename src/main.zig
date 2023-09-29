const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));
const ecs = @import("ecs.zig");
const components = @import("components.zig");
const systems = @import("systems.zig");
const common = @import("common.zig");

fn initEntitiesAndComponents(scene: *ecs.Scene, texture: r.Texture) !void {
    try ecs.addEntity(scene, .{}, null, null, null, null);
    try ecs.addEntity(scene, null, components.SpriteComponent{ .texture = texture, .source = r.Rectangle{
        .x = 0,
        .y = 0,
        .width = 32,
        .height = 32,
    }, .width = 32, .height = 32, .origin = common.Vector2{ .x = 16, .y = 16 } }, components.MovementComponent{
        .speed = 50,
    }, components.TransformComponent{ .position = .{
        .x = 100,
        .y = 100,
    } }, null);
}

fn update(scene: *ecs.Scene, deltaTime: f32) void {
    systems.moveEntities(scene.movements, &scene.transforms, deltaTime);
    systems.randomWalk(scene.randomWalkers, &scene.transforms, deltaTime);
    systems.renderSprites(scene.sprites, scene.transforms);
}

pub fn main() !void {
    r.InitWindow(960, 540, ".");
    r.SetTargetFPS(144);
    defer r.CloseWindow();

    const texture = r.LoadTexture("spritesheet.png");
    defer r.UnloadTexture(texture);
    var scene = ecs.initScene();
    try initEntitiesAndComponents(&scene, texture);
    var time = std.time.milliTimestamp();
    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        if (std.time.milliTimestamp() - time > 1000) {
            time = std.time.milliTimestamp();
            try ecs.addEntity(&scene, null, .{ .texture = texture, .source = r.Rectangle{
                .x = 0,
                .y = 0,
                .width = 32,
                .height = 32,
            }, .width = 32, .height = 32, .origin = common.Vector2{ .x = 16, .y = 16 } }, null, components.TransformComponent{ .position = common.Vector2{ .x = 100, .y = 100 } }, components.RandomWalker{});
        }
        r.ClearBackground(r.BLACK);
        update(&scene, r.GetFrameTime());
        r.EndDrawing();
        r.EndMode2D();
    }

    ecs.deinitScene(&scene);
}
