const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));
const ecs = @import("ecs.zig");
const components = @import("components.zig");
const systems = @import("systems.zig");

fn initEntitiesAndComponents(scene: *ecs.Scene, texture: r.Texture) !void {
    try scene.entities.append(.{ .id = 0 });
    try scene.entities.append(.{ .id = 1 });

    try scene.cameras.append(.{});
    try scene.cameras.append(null);

    try scene.sprites.append(null);
    try scene.sprites.append(components.SpriteComponent{ .texture = texture, .source = r.Rectangle{
        .x = 0,
        .y = 0,
        .width = 32,
        .height = 32,
    } });

    try scene.movements.append(null);
    try scene.movements.append(components.MovementComponent{
        .speed = 50,
    });

    try scene.transforms.append(null);
    try scene.transforms.append(components.TransformComponent{ .position = .{
        .x = 100,
        .y = 100,
    } });
}

fn update(scene: *ecs.Scene, deltaTime: f32) void {
    systems.moveEntities(scene.movements, &scene.transforms, deltaTime);
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
    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);
        update(&scene, r.GetFrameTime());
        r.EndDrawing();
        r.EndMode2D();
    }

    ecs.deinitScene(&scene);
}
