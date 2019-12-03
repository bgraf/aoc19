
def parse_command(cmd):
    return (cmd[0], int(cmd[1:]))

with open('input') as f:
    paths = []
    for line in f.readlines():
        paths.append(list(map(parse_command, line.strip().split(','))))


points = set()

pos = [0, 0]
for (direction, length) in paths[0]:
    if direction == 'U':
        for i in range(length):
            pos[1] += 1
            points.add(tuple(pos))
    if direction == 'D':
        for i in range(length):
            pos[1] -= 1
            points.add(tuple(pos))
    if direction == 'L':
        for i in range(length):
            pos[0] -= 1
            points.add(tuple(pos))
    if direction == 'R':
        for i in range(length):
            pos[0] += 1
            points.add(tuple(pos))

pos = [0, 0]
points2 = set()
for (direction, length) in paths[1]:
    if direction == 'U':
        for i in range(length):
            pos[1] += 1
            points2.add(tuple(pos))
    if direction == 'D':
        for i in range(length):
            pos[1] -= 1
            points2.add(tuple(pos))
    if direction == 'L':
        for i in range(length):
            pos[0] -= 1
            points2.add(tuple(pos))
    if direction == 'R':
        for i in range(length):
            pos[0] += 1
            points2.add(tuple(pos))

common = points.intersection(points2)

min_dist = min(abs(x) + abs(y) for (x,y) in common)

print(min_dist)