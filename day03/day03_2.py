
def parse_command(cmd):
    return (cmd[0], int(cmd[1:]))

with open('input') as f:
    paths = []
    for line in f.readlines():
        paths.append(list(map(parse_command, line.strip().split(','))))


points = set()

p1dist = {}
p2dist = {}

pos = [0, 0]
steps = 0
for (direction, length) in paths[0]:
    if direction == 'U':
        for i in range(length):
            steps += 1
            pos[1] += 1
            p = tuple(pos)
            points.add(p)
            if p not in p1dist:
                p1dist[p] = steps
    if direction == 'D':
        for i in range(length):
            steps += 1
            pos[1] -= 1
            p = tuple(pos)
            points.add(p)
            if p not in p1dist:
                p1dist[p] = steps
    if direction == 'L':
        for i in range(length):
            steps += 1
            pos[0] -= 1
            p = tuple(pos)
            points.add(p)
            if p not in p1dist:
                p1dist[p] = steps
    if direction == 'R':
        for i in range(length):
            steps += 1
            pos[0] += 1
            p = tuple(pos)
            points.add(p)
            if p not in p1dist:
                p1dist[p] = steps

pos = [0, 0]
points2 = set()
steps = 0
for (direction, length) in paths[1]:
    if direction == 'U':
        for i in range(length):
            steps += 1
            pos[1] += 1
            p = tuple(pos)
            points2.add(p)
            if p not in p2dist:
                p2dist[p] = steps
    if direction == 'D':
        for i in range(length):
            steps += 1
            pos[1] -= 1
            p = tuple(pos)
            points2.add(p)
            if p not in p2dist:
                p2dist[p] = steps
    if direction == 'L':
        for i in range(length):
            steps += 1
            pos[0] -= 1
            p = tuple(pos)
            points2.add(p)
            if p not in p2dist:
                p2dist[p] = steps
    if direction == 'R':
        for i in range(length):
            steps += 1
            pos[0] += 1
            p = tuple(pos)
            points2.add(p)
            if p not in p2dist:
                p2dist[p] = steps

common = points.intersection(points2)
for p in common:
    print(p)

min_dist = min(p1dist[(x,y)] + p2dist[(x,y)] for (x,y) in common)

print(min_dist)
