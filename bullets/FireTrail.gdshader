shader_type canvas_item;
render_mode blend_add; // Добавочный режим смешивания, подходящий для огня

// Основные параметры
uniform vec4 base_color : source_color = vec4(1.0, 0.5, 0.0, 1.0); // Основной цвет огня
uniform vec4 glow_color : source_color = vec4(1.0, 0.6, 0.2, 1.0); // Цвет свечения
uniform float s_scale_y : hint_range(0.1, 2.0) = 1.0; // Масштабирование по оси Y
uniform float l_s_scale_y : hint_range(0.1, 2.0) = 1.0; // Дополнительное масштабирование по оси Y для светового эффекта
uniform float lness : hint_range(0.0, 5.0) = 1.0; // Интенсивность светового эффекта
uniform float lness2 : hint_range(0.0, 1.0) = 0.0; // Дополнительный параметр светового эффекта

// Текстуры шума и цветовая кривая
uniform sampler2D noise : repeat_enable, filter_nearest_mipmap_anisotropic; // Текстура шума для создания огненных эффектов
uniform sampler2D noise2 : repeat_enable, filter_nearest_mipmap_anisotropic; // Вторая текстура шума для дополнительных вариаций
uniform sampler2D colo_curve; // Текстура для управления цветовой гаммой огня

// Функция для смешивания текстур шума и создания огненного эффекта
vec4 f1(vec2 uv, float time) {
    vec4 nv2 = texture(noise, uv + vec2(time, 0.0));
    vec4 n2v2 = texture(noise2, uv + vec2(time * 0.8, 0.0));
    nv2.a = max(0.0, nv2.a + uv.x - 1.0);
    n2v2.a = max(0.0, n2v2.a + uv.x - 1.0); 
    return nv2 * n2v2;
}

void fragment() {
    vec2 mUV = UV * 4.0 - 1.5;
    vec2 uv = mUV * vec2(1.0, s_scale_y); 
    float time = TIME;

    vec2 cuv = mUV - vec2(0.5); 
    float d2c = length(cuv);
    vec4 color = base_color; // Используем базовый цвет

    // Создание и смешивание огненного эффекта из шумовых текстур
    color *= (f1(uv, time) + f1(uv + vec2(0.1, 0.0), time + 11.514) + f1(uv + vec2(0.05, 0.0), time + 14.14));

    color.a -= 1.0;
    color.a = -pow(color.a, 2.0) + 1.0;

    // Управление цветом огня на основе альфа-канала
    color.rgb = texture(colo_curve, vec2(color.a, 0.0)).rgb;

    // Добавление случайного эффекта мерцания
    float randmoo = texture(noise2, mUV + vec2(time, -time)).a;
    randmoo = mix(randmoo, 0.0, mUV.x);
    color.a *= smoothstep(0.5, 0.48 - (0.2 - min(mUV.x, 1.0) * 0.2), d2c + randmoo * 0.4);

    COLOR = color;
    COLOR.rgb = mix(COLOR.rgb, vec3(0.0), smoothstep(0.00001, 0.0, color.a));

    // Настройка светового эффекта
    float d2c_l = length(UV * vec2(1.0, l_s_scale_y) - vec2(0.58, 0.5 * l_s_scale_y));
    float l = -log(d2c_l + lness2) * lness;
    float randmoo2 = texture(noise2, vec2(time, -time)).a;

    // Добавляем эффект свечения
    COLOR += glow_color * l;

    // Уменьшение прозрачности ближе к краям текстуры
    COLOR.a *= smoothstep(0.5, 0.1, length(UV - vec2(0.5)));
}