shader_type canvas_item;

// Параметры частиц
uniform int particle_count : hint_range(0, 200) = 50; // Количество частиц
uniform float min_speed : hint_range(0.15, 0.4) = 0.15; // Минимальная скорость частицы
uniform float max_speed : hint_range(0.4, 1.0) = 0.75; // Максимальная скорость частицы
uniform float min_size : hint_range(0.001, 0.002) = 0.0015; // Минимальный размер частицы (единое значение для x и y)
uniform float max_size : hint_range(0.003, 0.005) = 0.003; // Максимальный размер частицы (единое значение для x и y)
uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.1, 1.0); // Цвет свечения частицы
uniform float glow_intensity : hint_range(0.0, 2.0) = 1.0; // Интенсивность свечения
uniform float angle_degrees : hint_range(0.0, 360.0) = 90.0; // Угол полета частиц в градусах

// Хэш-функции для генерации случайных чисел
float Hash(float x) {
    return fract(sin(x * 18.34) * 43758.5453);
}

float Hash2(float x) {
    return fract(sin(x * 34.78) * 12467.6453);
}

// Генерация частицы на основе ее индекса
vec2 generate_particle_position(int index, float time) {
    float h1 = Hash(float(index));
    float h2 = Hash2(float(index));
    float speed = mix(min_speed, max_speed, h2);

    // Преобразование угла в радианы и вычисление направления движения
    float angle_radians = radians(angle_degrees);
    vec2 direction = vec2(cos(angle_radians), sin(angle_radians));

    // Вычисление позиции частицы с учетом угла
    float x = mod(h1 + time * speed * direction.x, 1.0);
    float y = mod(h2 + time * speed * direction.y, 1.0);
    return vec2(x, y);
}

void fragment() {
    vec2 uv = UV;
    float time = TIME;
    float output = 0.0;

    // Учёт соотношения сторон экрана
    float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    uv.y *= aspect_ratio;

    // Перебор всех частиц и вычисление их влияния на текущий пиксель
    for (int i = 1; i <= particle_count; i++) {
        vec2 particle_pos = generate_particle_position(i, time);
        vec2 particle_dist = uv - particle_pos;

        // Генерация случайного размера для каждой частицы (одинаковое значение для x и y)
        float particle_size = mix(min_size, max_size, Hash(float(i)));
        float flicker = 0.5 + 0.5 * sin(time * 10.0 + Hash(float(i)) * 6.28); // Мерцание

        // Создание эффекта свечения вокруг частицы с учетом размера и мерцания
        float glow_effect = 1.0 - smoothstep(0.0, particle_size, length(particle_dist));
        output += glow_effect * glow_intensity * flicker;
    }

    // Окончательный цвет пикселя с учетом свечения частиц
    COLOR = vec4(glow_color.rgb * output, output);
}