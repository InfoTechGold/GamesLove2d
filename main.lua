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

    --criando a tabela de balas
    bullets={};
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
    --fazendo os zombies se mover para a minha direação
    for i,z in ipairs(zombies) do
        z.x=z.x +(math.cos(zombieRotation(z))*z.speed*dt);
        z.y=z.y +(math.sin(zombieRotation(z))*z.speed*dt);

        --criando a colisão do player com o zombies
        if(distancia(z.x,z.y,player.x,player.y)<30) then
            for i,z in ipairs(zombies)do
                zombies[i]=nil;
            end
        end
    end

    --criando as balas
    for i,b in ipairs(bullets)do
        b.x=b.x +(math.cos(b.direction)*b.speed*dt);
        b.y=b.y +(math.sin(b.direction)*b.speed*dt);
    end
    for i=#bullets,1,-1 do
        local b=bullets[i];
        if(b.x<0 or b.y<0 or b.x>love.graphics.getWidth() or b.y>love.graphics.getHeight())then
            table.remove(bullets,i);      
        end
    end
    for i,z in ipairs(zombies)do
        for j,b in ipairs(bullets)do
            if(distancia(z.x,z.y,b.x,b.y)<20)then
                z.dead=true;
                b.dead=true;
            end
        end
    end

    for i=#zombies,1,-1 do
        local z=zombies[i];

        if(z.dead==true)then
            table.remove(zombies,i);
        end
    end

    for i=#bullets,1,-1 do
        local b=bullets[i];

        if(b.dead==true)then
            table.remove(bullets,i);
        end
    end


end
function distancia(x1,y1,x2,y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2);
end

--função para o pegar a posição atual do meu mouse
function mouseRotation()
    
    return math.atan2(player.y-love.mouse.getY(),player.x-love.mouse.getX())+ math.pi;
end
--função para criar os zombies
function zombieSpawn()
    local zombie={}; --tabelas de zombie
    zombie.x=0; --dando nacimento aleatorio para os zombies
    zombie.y=0;--dando nacimento aleatorio para os zombies
    zombie.speed=100; --dando uma velocidade ao zombie

    --escolhendo direção aleatoria para os zumbies;
    local side=math.random(1,4);
    if(side==1)then
        zombie.x=-30;
        zombie.y=math.random(0,love.graphics.getHeight());
    elseif side==2 then
        zombie.x=love.graphics.getWidth()+30;
        zombie.y=math.random(0,love.graphics.getHeight());
    elseif(side==3)then
        zombie.x=math.random(0,love.graphics.getWidth());
        zombie.y=-30;
    elseif side==4 then
        zombie.x=math.random(0,love.graphics.getWidth());
        zombie.y=love.graphics.getHeight()+30;
    end



    zombie.dead=false;
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

--criando a função para criar as balas
function spawnBullets()
    local bullet={};
    bullet.x=player.x;
    bullet.y=player.y;
    bullet.dead=false;
    bullet.speed=500;
    bullet.direction=mouseRotation();
    table.insert(bullets,bullet);
end
--função para criar os tiros ao clicar no mouse
function love.mousepressed(x,y,button)
    if(button==1)then
        spawnBullets();
    end
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
    --desenhando as balas
    for i,b in ipairs(bullets)do
        love.graphics.draw(sprites.bullet,b.x,b.y,nil,0.3,0.3,sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2);
    end

end