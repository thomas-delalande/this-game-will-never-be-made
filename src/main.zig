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
    entities: std.ArrayList(Entity),
    cameras: std.ArrayList(?CameraComponent),
    sprites: std.ArrayList(?SpriteComponent),
    movements: std.ArrayList(?MovementComponent),
    transforms: std.ArrayList(?TransformComponent),
};

fn initEntitiesAndComponents(scene: *Scene, texture: r.Texture) !void {
    try scene.entities.append(.{ .id = 0 });
    try scene.entities.append(.{ .id = 1 });

    try scene.cameras.append(.{});
    try scene.cameras.append(null);

    try scene.sprites.append(null);
    try scene.sprites.append(SpriteComponent{ .texture = texture, .source = r.Rectangle{
        .x = 0,
        .y = 0,
        .width = 32,
        .height = 32,
    } });

    try scene.movements.append(null);
    try scene.movements.append(MovementComponent{
        .speed = 50,
    });

    try scene.transforms.append(null);
    try scene.transforms.append(TransformComponent{ .position = Vector2{
        .x = 100,
        .y = 100,
    } });
}
fn initScene() Scene {
    const allocator = std.heap.page_allocator;
    return Scene{
        .entities = std.ArrayList(Entity).init(allocator),
        .cameras = std.ArrayList(?CameraComponent).init(allocator),
        .sprites = std.ArrayList(?SpriteComponent).init(allocator),
        .movements = std.ArrayList(?MovementComponent).init(allocator),
        .transforms = std.ArrayList(?TransformComponent).init(allocator),
    };
}

fn deinitScene(scene: Scene) void {
    scene.entities.deinit();
    scene.cameras.deinit();
    scene.sprites.deinit();
    scene.movements.deinit();
    scene.transforms.deinit();
}

fn update(scene: *Scene, deltaTime: f32) void {
    moveEntities(scene.movements, &scene.transforms, deltaTime);
    renderSprites(scene.sprites, scene.transforms);
}
fn moveEntities(movements: std.ArrayList(?MovementComponent), transforms: *std.ArrayList(?TransformComponent), deltaTime: f32) void {
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
    for (movements.items, transforms.items) |movement, *transform| {
        if (movement) |m| {
            if (transform.*) |*t| {
                t.position.x += input.x * m.speed * deltaTime;
                t.position.y += input.y * m.speed * deltaTime;
            }
        }
    }
}

fn renderSprites(sprites: std.ArrayList(?SpriteComponent), transforms: std.ArrayList(?TransformComponent)) void {
    for (sprites.items, transforms.items) |sprite, transform| {
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
    var scene = initScene();
    try initEntitiesAndComponents(&scene, texture);
    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);
        update(&scene, r.GetFrameTime());
        r.EndDrawing();
        r.EndMode2D();
    }

    deinitScene(scene);
}
