--criando a função para carregar o jogo
function love.load()
    --reiniciando a seed para zombies aleatorios no começo do jogo
    math.randomseed(os.time());
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
    --varival para controlar se o jogo ta rodando ou parado
    gameState=2;
    --variavel de controle para spawnar os zumbis
    max_timer=2;
    timer=max_timer;
    pontos=0;
    fonte=love.graphics.newFont(30);



end

--criando a função que roda o tempo todo delta timer
function love.update(dt)
    if(gameState==2)then
        --condição para o player ir pra cima
        if(love.keyboard.isDown("w") and player.y>0)then
            player.y=player.y-player.speed*dt;
        end
        --condição para o player ir pra baixo
        if(love.keyboard.isDown("s") and player.y<love.graphics.getHeight())then
            player.y=player.y+player.speed*dt;
        end
        --condição para o player ir pra esquerda
        if(love.keyboard.isDown("a") and player.x>0)then
            player.x=player.x-player.speed*dt;
        end
        --condição para o player ir pra direita
        if(love.keyboard.isDown("d") and player.x<love.graphics.getWidth())then
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
                    gameState=1;

                    player.x=love.graphics.getWidth()/2;
                    player.y=love.graphics.getHeight()/2;
                    max_timer=2;
                    timer=max_timer;
                end
            end
        end

        --fazendo as balas se mover
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

        --checando colisão da bala com o zumbi
        for i,z in ipairs(zombies)do
            for j,b in ipairs(bullets)do
                if(distancia(z.x,z.y,b.x,b.y)<20)then
                    z.dead=true;
                    b.dead=true;
                    pontos=pontos+1;
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
        --diminuindo meu tempo
        timer=timer-dt;
        --condição para criar meu zombies
        if(timer<=0)then
            --crriando os zumbies
            zombieSpawn();
            --resetando o temporizador
            max_timer=0.90*max_timer;
            timer=max_timer;
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
--[[function love.keypressed(key)
    if(key=='space')then
        --criando o zombie
        zombieSpawn();
    end
end]]
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
    if(button==1 and gameState==2)then
        spawnBullets();
    elseif(button==1 and gameState==1)then
        gameState=2;
        pontos=0;   
    end
end



--função para desenhar as sprites do nosso jogo
function love.draw()
    --desenhando o background do jogo
    love.graphics.draw(sprites.background,0,0);
   
    --desenhando o player do jogo
    love.graphics.draw(sprites.player,player.x,player.y,mouseRotation(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2);
    if(gameState==2)then
        --percorrendo a tabela de zombies e criando os zombies da tabela
        for i,z in ipairs(zombies)do
            love.graphics.draw(sprites.zombie,z.x,z.y,zombieRotation(z),nil,nil,sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2); --criando os zombies que tem dentro da tabela
        end
        --desenhando as balas
        for i,b in ipairs(bullets)do
            love.graphics.draw(sprites.bullet,b.x,b.y,nil,0.3,0.3,sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2);
        end
    elseif(gameState==1)then  
        love.graphics.setFont(fonte);
        love.graphics.printf("toque na tela para começar o jogo: " ,0, 0 ,love.graphics.getWidth() , "center");
    end 
    love.graphics.setFont(fonte);
    love.graphics.printf(" Pontos : " .. pontos, 0, love.graphics.getHeight()-100,love.graphics.getWidth(), "center");
end