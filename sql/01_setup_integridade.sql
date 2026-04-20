
-- Script de Relacionamentos e Chaves Estrangeiras
-- Garante que o banco esteja íntegro

-- Relacionando Pesagens com Animais
ALTER TABLE pesagens 
ADD CONSTRAINT fk_animais_pesagens 
FOREIGN KEY (id_animal) REFERENCES animais (id_animal) ON DELETE CASCADE;

-- Relacionando Sanitário com Animais
ALTER TABLE sanitario 
ADD CONSTRAINT fk_animais_sanitario 
FOREIGN KEY (id_animal) REFERENCES animais (id_animal) ON DELETE CASCADE;

-- Relacionando Performance com Animais
ALTER TABLE performance 
ADD CONSTRAINT fk_animais_performance 
FOREIGN KEY (id_animal) REFERENCES animais (id_animal) ON DELETE CASCADE;
