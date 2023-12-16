---
layout: post
title:  "Псевдо 3D с помощью Raycasting"
categories: programming
lang: ru
ref: raycast
---

Сегодня мы рассмотрим алгоритм, который был использован в игре Wolfenstein 3D для имитации 3D пространства.

Ray casting можно перевести как "бросание лучей", что хорошо выражает суть алгоритма. Весь
алгоритм сводится к тому, что мы бросаем N-ое количество лучей и на основание расстояния каждого луча (от начала луча до первого препятствия)
отображаем соответствующую вертикальную линию на экране.

Итак, наши действующие лица:
* 2D плоскоcть (карта)
* Игрок который может передвигаться по 2D плоскоcти

Для простоты, карту будем представлять в виде 2-мерного массива 10 на 10 (хотя есть варианты по оптимальнее)  
где 1 - cтена и 0 - пустое место:  
```python
world_map = [
    [1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,0,0,1,0,0,1,0,0,1],
    [1,0,0,1,0,0,1,0,0,1],
    [1,0,0,1,0,0,1,0,0,1],
    [1,0,0,1,0,0,1,0,0,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1]
]
```

Размер "ячейки" возьмем за 80 на 80 пикселей. Так как у нас карта 10x10 ячеек, удобно сделать так, чтобы размер экрана был
800x800(10 * 80 x 10 * 80)

Поместим вышеуказанные параметры в словарь `config`:
```python
config = {
    "screen_w" : 800,
    "screen_h" : 800,
    'fps' : 60,
    'tile' : 80
}
colors = {
    'grey' : (220, 220, 220)
	#...
}
```

Базовые вещи, связанные с pygame я опускаю. Cоздав игровой цикл, поместим внутри него функцию, которая будет отрисовывать карту

```python
def draw_map():
    for y in range(len(world_map)):
        for x in range(len(world_map[y])):
            if world_map[y][x] == 1:
	# в координате (x, y), нарисуй квадрат с шириной и высотой config['tile']
                pygame.draw.rect(screen, colors['grey'], \
                    (x * config['tile'], y * config['tile'], config['tile'], config['tile']), 2)
```

Функция `draw_map()` рисует нашу 2D карту из world_map, получается такой вид сверху на наш игровой мир. Данная функция 
отлично показывает, что мы "находимся" в 2D мире.

Давайте же добавим игрока в нашу игру. Для начала создадим для него словарь конфигурации
```python
player_config = {
    'pos_x' : int(config['screen_w'] / 2), # начальная позиция игрока по координате x
    'pos_y' : int(config['screen_h'] / 2), # начальная позиция игрока по координате y
    'angle' : 0, # угол поворота игрока в радианах, 0 - направление прямо на восток как и тригонометрическом круге.
    'speed' : 5  # скорость игрока
}
```

Само игрока можно описать в отдельном классе:
```python
class Player:
    def __init__(self):
        self.pos_x = player_config['pos_x']
        self.pos_y = player_config['pos_y']
        self.angle = player_config['angle']
        self.speed = player_config['speed']

    @property
    def pos(self):
        return (self.pos_x, self.pos_y)

    def movement(self):
        sin = math.sin(self.angle)
        cos = math.cos(self.angle)
        keys = pygame.key.get_pressed()

        #формулы привидения, и тригонометричкский круг на кординтах pygame
        if keys[pygame.K_w]:
	# идем вперед
            self.pos_x += self.speed * cos
            self.pos_y += self.speed * sin
        if keys[pygame.K_s]:
	# идем назад
            self.pos_x += -self.speed * cos
            self.pos_y += -self.speed * sin
        if keys[pygame.K_a]:
            self.pos_x += self.speed * sin
            self.pos_y += -self.speed * cos
        if keys[pygame.K_d]:
            self.pos_x += -self.speed * sin
            self.pos_y += self.speed * cos
        if keys[pygame.K_LEFT]:
            self.angle -= 0.05
        if keys[pygame.K_RIGHT]:
            self.angle += 0.05
```

Самое важное в этом классе метод `movement()`, давайте рассмотрим как он работает.

Если бы мы делали 2D управление, то все было бы банально: нажали стрелку вниз, увеличили `self.pos_y`. Нажали
стрелку вправо, увеличили `self.pos_x`.  
В нашей же псевдо-3D игре, нужно чтоб при нажатии стрелки верх, персонаж шел в направлении куда он смотрит (`self.angle`), а при нажатии
стрелки влево или вправо, персонаж должен двигаться по линии перпендикулярной его направлению.

Итак, вначале мы рассчитываем `sin и cos` угла поворота нашего персонажа. Эти sin и cos, есть нечто иное как вектор направления нашего
персонажа, поэтому нам достаточно растянуть этот вектор умножением на скорость игрока (self.speed), и прибавить полученный вектор,
к вектору нашего местоположения `([self.pos_x, self.pos_y])`. Таким образом мы будем двигаться вперед (к точке [sin, cos] на окружности).

Движения влево и вправо, вытекают из формул приведения. То есть: если направление игрока `[cos(self.angle), sin(self.angle)]`,
то движение вправо есть движение по перпендикулярной линии, то есть под уголом 90 градусов, тогда получаем по формуле приведения
`cos(p/2 + self.angle) = -sin(self.angle)` и `sin(p/2 + self.angle) = cos(self.angle)`.

Идти назад довольно просто, ведь это противоположное направление переда(куда смотрит игрок), поэтому мы можем просто инвертировать 
вектор направления умножив его на отрицательную скорость.



Вы можете легко убедиться, что мы рассчитываем правильные направления с помощью
[интерактивного тригонометрического круга](https://www.mathsisfun.com/algebra/trig-interactive-unit-circle.html)

Что ж, теперь когда у нас есть игрок, давайте создадим простой метод отрисовки его направления на 2D карте:
```python
def draw_main_ray():
    pygame.draw.line(screen, colors['red'], player.pos, (
        player.pos_x + config['screen_w'] * math.cos(player.angle),
        player.pos_y + config['screen_w'] * math.sin(player.angle)
    ), 4)
```

Итак, наша игра до сих пор в 2D, и наш игровой цикл выглядит так:
```python
while running:
	#...
    screen.fill(colors['black'])
    draw_map()
    player.movement()
    draw_main_ray()
	#...
```

Настало время реализовать алгоритм raycasting. Для начала обьявим несколько вспомогательных переменных:

```python
FOV = math.pi / 3	# Угол обзора
HALF_FOV = FOV / 2	# Половина угла обзора
RAYS = int(config['screen_w'] / 10)	# Количество пускаемых лучей. Здесь ширина каждой вертикальной линии, будет равна 10 
# Чем шире вертикальная линия, тем выше производительность
DELTA_ANGLE = FOV / RAYS	# Каждая вертикальная линия занимает определенную ширину на экране, а также определенную часть FOV
MAX_DEPTH = 800	# Максимальная длина raycast луча
DIST = RAYS / (2 * math.tan(HALF_FOV))
PROJ_COEFF = 3 * DIST * config["tile"] # multiplied by 3 to make projection bigger
SCALE = config['screen_w'] // RAYS # Ширина вертикальной линии
```

```python
def raycast():
    cur_angle = player.angle - HALF_FOV
    xo, yo = player.pos

    for ray in range(RAYS):
        cos_a = math.cos(cur_angle)
        sin_a = math.sin(cur_angle)
        for depth in range(MAX_DEPTH):
            x = (xo + depth * cos_a)
            y = (yo + depth * sin_a)
	    # 2d отрисовка raycast луча
            #pygame.draw.line(screen, colors['white'], player.pos, (x, y), 2)
            if world_map[int(y) // config['tile']][int(x) // config['tile']] == 1:
                depth *= math.cos(player.angle - cur_angle) # fish eye fix
                proj_height = 0
                if depth > 0:
                    proj_height = PROJ_COEFF / depth
                #Rect(left, top, width, height)
                pygame.draw.rect(screen, colors['white'], 
                    (ray * SCALE, config['screen_h'] // 2 - proj_height // 2, SCALE, proj_height ))
                break
        cur_angle += DELTA_ANGLE
```

Давайте рассмотрим как работает эта функция, и какую роль в ней играют `DIST` и `PROJ_COEFF`

Итак, у нас есть угол обзора FOV, для самой четкой картинки мы можем выпускать столько же лучей, сколько у нас градусов
в FOV, но это тяжело переваривает python. Поэтому у нас есть переменная DELTA_ANGLE, которая определяет диапазон, через который мы пускаем лучи.

`cur_angle` вначале равняется крайнему левому лучу FOV. Далее у нас идет цикл, который отработает RAYS(количество лучей) раз.
На каждой итерации этого цикла мы будем рассчитывать sin и cos луча текущего угла `cur_angle`, в конце же итерации мы увеличиваем
текущий угол на DELTA_ANGLE (а могли бы увеличивать на 1, если б RAYS==FOV и мы писали на C/C++).

![FOV](/assets/imgs/raycast/Rays.png)

Затем идет конструкция `for depth in range(MAX_DEPTH)`, которая каждый раз увеличивает длину нашего луча(depth) на 1, до тех пор
пока он не столкнется со стеной или же не достигнет длины MAX_DEPTH. Поскольку `cos_a и sin_a` являются вектором направления луча,
мы увеличиваем этот единичный вектор умножением на depth и прибавляем его к вектору местоположения игрока `[xo, yo]`. Так мы получаем,
координаты конца луча [x, y], как же определить попадают они в стенку или нет? Все просто, сначала мы переходим из пиксельной 
системы измерения к клеточной, для этого делим координаты на размер ячейки(`config['tile']`). Далее нам остается проверить,
что находится в `world_map` по вычисленным координатам. Если там находится стена, то мы отрисовываем вертикальную линию и выходим из
цикла `for depth in range(MAX_DEPTH)`, если же ничего нет, то цикл продолжается.

Осталось понять "Как же рисуется вертикальная линия? Как определить ее высоту?". Спешу ответить на эти вопросы.
Вспомним две вспомогательные переменные:

```python
DIST = RAYS / (2 * math.tan(HALF_FOV))
PROJ_COEFF = 3 * DIST * config["tile"] # multiplied by 3 to make projection bigger
```
![Проекция вид сверху](/assets/imgs/raycast/Projection.png)

Игрок и его угол обзора образуют экран проекции, длина этого экрана составляет количество лучей(RAYS).
Нам нужно найти расстояние(DIST) до экрана проекции, чтобы правильно рассчитывать высоту стены(вертикальной линии).

![Проекция вид сбоку](/assets/imgs/raycast/Projection2.png)

Высота стены выводится из подобия треугольников. В коде мы умножаем расстояние луча на `math.cos(player.angle - cur_angle)`
чтобы убрать эффект рыбьего глаза. Далее мы для начала устанавливаем высоту стены 0, в случае если длина не будет больше нуля,
это позволит нам не рисовать очень далекие стены, если же длина луча больше 0, мы рассчитываем высоту стены с помощью `PROJ_COEF`

```python
depth *= math.cos(player.angle - cur_angle) # fish eye fix
proj_height = 0
if depth > 0:
	proj_height = PROJ_COEFF / depth
pygame.draw.rect(screen, colors['white'], (ray * SCALE, config['screen_h'] // 2 - proj_height // 2, SCALE, proj_height ))
```

### Заключение

Теперь в игровом цикле мы можем убрать все функции связанные с 2D отрисовкой, и использовать вместо них функцию `raycast`. Поздравляю,
вы создали псевдо 3D мир.

### Источники

* https://www.youtube.com/watch?v=SmKBsArp2dI
* https://lodev.org/cgtutor/raycasting.html
