c = document.getElementById('draw')
ctx = c.getContext('2d')

delta = 0
now = 0
before = Date.now()
elapsed = 0

# c.width = window.innerWidth
# c.height = window.innerHeight

c.width = 800
c.height = 600

keysDown = {}


window.addEventListener("keydown", (e) ->
    keysDown[e.keyCode] = true
, false)

window.addEventListener("keyup", (e) ->
    delete keysDown[e.keyCode]
, false)

setDelta = ->
    now = Date.now()
    delta = (now - before) / 1000
    before = now

enemies = []
toSpawn = 2
player = {
    x: 400,
    y: 300,
}

bullets = []

playerSpeed = 100
toShot = 0
toEnemy = 0
toToEnemy = 2
noice = 0
ded = false

collides = (a, b, aw, ah, bw, bh) ->
    a.x + aw > b.x and a.x < b.x + bw and a.y + ah > b.y and a.y < b.y + bh

update = ->
    setDelta()

    if keysDown[65]
        player.x -= delta * playerSpeed

    if keysDown[68]
        player.x += delta * playerSpeed

    if keysDown[87]
        player.y -= delta * playerSpeed

    if keysDown[83]
        player.y += delta * playerSpeed

    if keysDown[39] and toShot <= 0
        toShot = 0.2
        bullets.push({
            x: player.x,
            y: player.y + 5,
            vx: 200,
            vy: 0,
        })

    if keysDown[37] and toShot <= 0
        toShot = 0.2
        bullets.push({
            x: player.x,
            y: player.y + 5,
            vx: -200,
            vy: 0,
        })

    if keysDown[38] and toShot <= 0
        toShot = 0.2
        bullets.push({
            x: player.x,
            y: player.y + 5,
            vx: 0,
            vy: -200,
        })

    if keysDown[40] and toShot <= 0
        toShot = 0.2
        bullets.push({
            x: player.x,
            y: player.y + 5,
            vx: 0,
            vy: 200,
        })

    toShot -= delta
    toEnemy -= delta

    for bullet in bullets
        bullet.x += bullet.vx * delta
        bullet.y += bullet.vy * delta

    for enemy in enemies
        if not enemy.dead
            enemy.x += enemy.vx * delta
            enemy.y += enemy.vy * delta

            if collides(player, enemy, 20, 20, 20, 10)
                ded = true

            for bullet in bullets
                if collides(bullet, enemy, 60, 10, 20, 10)
                    enemy.dead = true
                    noice += 1


    if toEnemy <= 0
        toToEnemy -= 0.05
        toEnemy = toToEnemy
        enemies.push({
            x: -50,
            y: 1000 * Math.random(),
            vx: 200 * Math.random(),
            vy: 200 * (Math.random() - 0.5),
        })

        enemies.push({
            x: 900,
            y: 1000 * Math.random(),
            vx: -200 * Math.random(),
            vy: 200 * (Math.random() - 0.5),
        })


    draw(delta)

    window.requestAnimationFrame(update)


draw = (delta) ->
    ctx.clearRect(0, 0, c.width, c.height)

    if ded
        ctx.font = '42px Visitor'
        ctx.fillText('ded', 350, 280)
        return

    ctx.save()
    ctx.font = '22px Visitor'
    ctx.fillText('Noice! x ' + noice, 50, 20)

    ctx.font = '12px Visitor'
    ctx.fillStyle = '#fe2304'
    ctx.fillRect(player.x, player.y, 20, 20)
    ctx.fillStyle = '#000000'

    for bullet in bullets
        ctx.fillText('U wot m8?', bullet.x, bullet.y)

    for enemy in enemies
        if not enemy.dead
            ctx.fillStyle = '#000000'
            ctx.fillRect(enemy.x, enemy.y, 10, 20)
        else
            ctx.fillStyle = '#999999'
            ctx.fillRect(enemy.x, enemy.y, 20, 10)

    ctx.restore()


do ->
    w = window
    for vendor in ['ms', 'moz', 'webkit', 'o']
        break if w.requestAnimationFrame
        w.requestAnimationFrame = w["#{vendor}RequestAnimationFrame"]

    if not w.requestAnimationFrame
        targetTime = 0
        w.requestAnimationFrame = (callback) ->
            targetTime = Math.max targetTime + 16, currentTime = +new Date
            w.setTimeout (-> callback +new Date), targetTime - currentTime


update()
