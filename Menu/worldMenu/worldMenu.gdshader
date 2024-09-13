shader_type canvas_item;

uniform float projector_power : hint_range(0, 1) = 0.5;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.5; // Интенсивность виньетирования
uniform float vignette_radius : hint_range(0.0, 1.0) = 0.5;    // Радиус виньетирования

void fragment() {
    // Координаты центра экрана
    vec2 screen_center = vec2(0.5, 0.5);

    // Вычисляем расстояние от текущего пикселя до центра экрана
    float dist = distance(UV, screen_center);

    // Рассчитываем силу виньетирования (инвертированное)
    float vignette = smoothstep(vignette_radius - vignette_intensity, vignette_radius, dist);

    // Затемняем экран в зависимости от значения projector_power и виньетирования
    float darkening_factor = projector_power * vignette;

    // Формируем цвет затемнения (черный с альфа-прозрачностью)
    vec4 darkening_layer = vec4(0.0, 0.0, 0.0, darkening_factor);

    // Выводим результат затемняющего слоя
    COLOR = darkening_layer;
}