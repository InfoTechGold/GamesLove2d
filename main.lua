--criando a função para carregar o jogo
function love.load()

    sprites={}; --criando a tabela sprites para guardar todas as nossas sprites
    sprites.background=love.graphics.newImage('background.png');--sprite do background
    sprites.bullet=love.graphics.newImage('bullet.png');--sprite das balas
    sprites.zombie=love.graphics.newImage('zombie.png');--sprites dos zombies
    sprites.player=love.graphics.newImage('player.png'); -- sprites do player

    --criando a tabela do player
    player={};
    player.x=love.graphics.getWidth()/2; --desenhando o player no meio da tela da largura
    player.y=love.graphics.getHeight()/2; -- desenhando o player no meio da tela na altura
    player.speed=180; -- dando uma velocidade ao player de 3 de speed vs dt 60

    --criando o zombie a tabela de varios zombies
    zombies={};
end

--criando a função que roda o tempo todo delta timer
function love.update(dt)
    --condição para o player ir pra cima
    if(love.keyboard.isDown("w"))then
        player.y=player.y-player.speed*dt;
    end
    --condição para o player ir pra baixo
    if(love.keyboard.isDown("s"))then
        player.y=player.y+player.speed*dt;
    end
    --condição para o player ir pra esquerda
    if(love.keyboard.isDown("a"))then
        player.x=player.x-player.speed*dt;
    end
    --condição para o player ir pra direita
    if(love.keyboard.isDown("d"))then
        player.x=player.x+player.speed*dt;
    end
end
--função para o pegar a posição atual do meu mouse
function mouseRotation()
    
    return math.atan2(player.y-love.mouse.getY(),player.x-love.mouse.getX())+ math.pi;
end
--função para criar os zombies
function zombieSpawn()
    local zombie={}; --tabelas de zombie
    zombie.x=math.random(0,love.graphics.getWidth()); --dando nacimento aleatorio para os zombies
    zombie.y=math.random(0, love.graphics.getHeight());--dando nacimento aleatorio para os zombies
    zombie.speed=100; --dando uma velocidade ao zombie
    table.insert(zombies,zombie); --adicionando o zombie a outra tabela
end
--função para checar se toquei no spaço do teclado 
function love.keypressed(key)
    if(key=='space')then
        --criando o zombie
        zombieSpawn();
    end
end
function zombieRotation(enemy)
    return math.atan2(player.y-enemy.y,player.x-enemy.x);
end
--função para desenhar as sprites do nosso jogo
function love.draw()
    --desenhando o background do jogo
    love.graphics.draw(sprites.background,0,0);
    --desenhando o player do jogo
    love.graphics.draw(sprites.player,player.x,player.y,mouseRotation(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2);
    --percorrendo a tabela de zombies e criando os zombies da tabela
    for i,z in ipairs(zombies)do
        love.graphics.draw(sprites.zombie,z.x,z.y,zombieRotation(z),nil,nil,sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2); --criando os zombies que tem dentro da tabela
    end

end