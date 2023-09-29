const std = @import("std");
const components = @import("components.zig");
const common = @import("common.zig");
const r = @cImport(@cInclude("raylib.h"));
const RndGen = std.rand.DefaultPrng;

pub fn moveEntities(movements: std.ArrayList(?components.MovementComponent), transforms: *std.ArrayList(?components.TransformComponent), deltaTime: f32) void {
    var input = common.Vector2{ .x = 0, .y = 0 };
    if (r.IsKeyDown(r.KEY_W)) {
        input.y = -1;
    }
    if (r.IsKeyDown(r.KEY_A)) {
        input.x = -1;
    }
    if (r.IsKeyDown(r.KEY_S)) {
        input.y = 1;
    }
    if (r.IsKeyDown(r.KEY_D)) {
        input.x = 1;
    }
    for (movements.items, transforms.items) |movement, *transform| {
        if (movement) |m| {
            if (transform.*) |*t| {
                t.position.x += input.x * m.speed * deltaTime;
                t.position.y += input.y * m.speed * deltaTime;
            }
        }
    }
}

pub fn renderSprites(sprites: std.ArrayList(?components.SpriteComponent), transforms: std.ArrayList(?components.TransformComponent)) void {
    for (sprites.items, transforms.items) |sprite, transform| {
        if (sprite) |s| {
            if (transform) |t| {
                r.DrawTexturePro(s.texture, s.source, r.Rectangle{
                    .x = t.position.x,
                    .y = t.position.y,
                    .width = s.width,
                    .height = s.height,
                }, r.Vector2{ .x = s.origin.x, .y = s.origin.y }, 0, r.WHITE);
            }
        }
    }
}

var rnd = RndGen.init(0);
pub fn randomWalk(randomWalkers: std.ArrayList(?components.RandomWalker), transforms: *std.ArrayList(?components.TransformComponent), deltaTime: f32) void {
    for (randomWalkers.items, transforms.items) |walker, *transform| {
        if (walker) |_| {
            if (transform.*) |*t| {
                var x = rnd.random().float(f32) * 32 - 16;
                var y = rnd.random().float(f32) * 32 - 16;
                t.position.x += x * deltaTime;
                t.position.y += y * deltaTime;
            }
        }
    }
}
