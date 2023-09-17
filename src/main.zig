const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));

const Vector2 = struct {
    x: f32,
    y: f32,
};

const CameraComponent = struct {};

const SpriteComponent = struct {
    texture: r.Texture,
    source: r.Rectangle,
};

const MovementComponent = struct {
    speed: f32,
};

const TransformComponent = struct { position: Vector2 };

const Entity = struct {
    id: i32,
};

const Scene = struct {
    entities: [2]Entity,
    cameras: [2]?CameraComponent,
    sprites: [2]?SpriteComponent,
    movements: [2]?MovementComponent,
    transforms: [2]?TransformComponent,
};

fn init(texture: r.Texture) Scene {
    return Scene{
        .entities = .{
            Entity{
                .id = 0,
            },
            Entity{
                .id = 1,
            },
        },
        .cameras = .{ CameraComponent{}, null },
        .sprites = .{ null, SpriteComponent{ .texture = texture, .source = r.Rectangle{
            .x = 0,
            .y = 0,
            .width = 32,
            .height = 32,
        } } },
        .movements = .{ null, MovementComponent{
            .speed = 50,
        } },
        .transforms = .{ null, TransformComponent{ .position = Vector2{
            .x = 100,
            .y = 100,
        } } },
    };
}

fn update(scene: *Scene, deltaTime: f32) void {
    moveEntities(scene.movements, &scene.transforms, deltaTime);
    renderSprites(scene.sprites, scene.transforms);
}
fn moveEntities(movements: [2]?MovementComponent, transforms: *[2]?TransformComponent, deltaTime: f32) void {
    var input = Vector2{ .x = 0, .y = 0 };
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
    for (movements, transforms) |movement, *transform| {
        if (movement) |m| {
            if (transform.*) |*t| {
                t.position.x += input.x * m.speed * deltaTime;
                t.position.y += input.y * m.speed * deltaTime;
            }
        }
    }
}

fn renderSprites(sprites: [2]?SpriteComponent, transforms: [2]?TransformComponent) void {
    for (sprites, transforms) |sprite, transform| {
        if (sprite) |s| {
            if (transform) |t| {
                r.DrawTexturePro(s.texture, s.source, r.Rectangle{
                    .x = t.position.x,
                    .y = t.position.y,
                    .width = 32,
                    .height = 32,
                }, r.Vector2{ .x = 16, .y = 16 }, 0, r.WHITE);
            }
        }
    }
}

pub fn main() !void {
    r.InitWindow(960, 540, ".");
    r.SetTargetFPS(144);
    defer r.CloseWindow();

    const texture = r.LoadTexture("spritesheet.png");
    defer r.UnloadTexture(texture);
    var scene = init(texture);
    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);
        update(&scene, r.GetFrameTime());
        r.EndDrawing();
        r.EndMode2D();
    }
}
