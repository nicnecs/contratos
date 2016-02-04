SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `addOnContratos` ;
CREATE SCHEMA IF NOT EXISTS `addOnContratos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `addOnContratos` ;

-- -----------------------------------------------------
-- Table `addOnContratos`.`indicesReajuste`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`indicesReajuste` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `sigla` VARCHAR(20) NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `aliquota` FLOAT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`contrato` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(60) NOT NULL,
  `pn` VARCHAR(30) NOT NULL,
  `divisao` VARCHAR(120) NOT NULL,
  `contato` INT NOT NULL,
  `status` INT NOT NULL,
  `categoria` INT NOT NULL,
  `assinatura` DATETIME NOT NULL,
  `encerramento` DATETIME NOT NULL,
  `inicioAtendimento` DATETIME NOT NULL,
  `fimAtendimento` DATETIME NOT NULL,
  `primeiraParcela` DATETIME NOT NULL,
  `parcelaAtual` INT NOT NULL,
  `mesReferencia` INT NOT NULL,
  `anoReferencia` INT NOT NULL,
  `quantidadeParcelas` INT NOT NULL,
  `global` TINYINT(1) NOT NULL,
  `vendedor` INT NOT NULL,
  `diaVencimento` INT NOT NULL,
  `referencialVencimento` INT NOT NULL,
  `diaLeitura` INT NOT NULL,
  `referencialLeitura` INT NOT NULL,
  `indicesReajuste_id` INT NOT NULL,
  `dataRenovacao` DATETIME NULL,
  `dataReajuste` DATETIME NULL,
  `valorImplantacao` FLOAT NOT NULL,
  `quantParcelasImplantacao` SMALLINT NOT NULL,
  `obs` LONGTEXT NOT NULL,
  `removido` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contrato_indicesReajuste1_idx` (`indicesReajuste_id` ASC),
  CONSTRAINT `fk_contrato_indicesReajuste1`
    FOREIGN KEY (`indicesReajuste_id`)
    REFERENCES `addOnContratos`.`indicesReajuste` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`tipoContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`tipoContrato` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `sigla` VARCHAR(15) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `bonus` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`subContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`subContrato` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `contrato_id` INT NOT NULL,
  `tipoContrato_id` INT NOT NULL,
  `removido` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_subContrato_contrato_idx` (`contrato_id` ASC),
  INDEX `fk_subContrato_tipoContrato1_idx` (`tipoContrato_id` ASC),
  CONSTRAINT `fk_subContrato_contrato`
    FOREIGN KEY (`contrato_id`)
    REFERENCES `addOnContratos`.`contrato` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subContrato_tipoContrato1`
    FOREIGN KEY (`tipoContrato_id`)
    REFERENCES `addOnContratos`.`tipoContrato` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`itens`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`itens` (
  `codigoCartaoEquipamento` INT NOT NULL,
  `businessPartnerCode` VARCHAR(30) NOT NULL,
  `contrato_id` INT NOT NULL,
  `subContrato_id` INT NOT NULL,
  PRIMARY KEY (`codigoCartaoEquipamento`),
  INDEX `fk_item_subContrato_idx` (`subContrato_id` ASC),
  CONSTRAINT `fk_item_subContrato`
    FOREIGN KEY (`subContrato_id`)
    REFERENCES `addOnContratos`.`subContrato` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`login` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idExterno` INT NULL,
  `nome` VARCHAR(50) NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `removido` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`historico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`historico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `login_id` INT NOT NULL,
  `data` DATETIME NOT NULL,
  `transacao` VARCHAR(120) NOT NULL,
  `tipoAgregacao` VARCHAR(100) NULL,
  `idAgregacao` INT NULL,
  `tipoObjeto` VARCHAR(100) NULL,
  `idObjeto` INT NULL,
  `propriedade` VARCHAR(100) NULL,
  `valor` VARCHAR(500) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_historico_login1_idx` (`login_id` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  CONSTRAINT `fk_historico_login`
    FOREIGN KEY (`login_id`)
    REFERENCES `addOnContratos`.`login` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`contador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`contador` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`bonus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`bonus` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `contrato_id` INT NOT NULL,
  `subContrato_id` INT NOT NULL,
  `contador_id` INT NOT NULL,
  `de` INT NOT NULL,
  `ate` INT NOT NULL,
  `valor` FLOAT NOT NULL,
  `removido` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_bonus_subContrato1_idx` (`subContrato_id` ASC),
  INDEX `fk_bonus_contador1_idx` (`contador_id` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  CONSTRAINT `fk_bonus_subContrato1`
    FOREIGN KEY (`subContrato_id`)
    REFERENCES `addOnContratos`.`subContrato` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bonus_contador1`
    FOREIGN KEY (`contador_id`)
    REFERENCES `addOnContratos`.`contador` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`cobranca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`cobranca` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `contrato_id` INT NOT NULL,
  `subContrato_id` INT NOT NULL,
  `contador_id` INT NOT NULL,
  `modalidadeMedicao` INT NOT NULL,
  `fixo` FLOAT NOT NULL,
  `variavel` FLOAT NOT NULL,
  `franquia` INT NOT NULL,
  `individual` TINYINT(1) NOT NULL,
  `removido` TINYINT(1) NOT NULL,
  INDEX `fk_cobranca_subContrato1_idx` (`subContrato_id` ASC),
  INDEX `fk_cobranca_contador1_idx` (`contador_id` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  CONSTRAINT `fk_cobranca_subContrato1`
    FOREIGN KEY (`subContrato_id`)
    REFERENCES `addOnContratos`.`subContrato` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cobranca_contador1`
    FOREIGN KEY (`contador_id`)
    REFERENCES `addOnContratos`.`contador` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`origemLeitura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`origemLeitura` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`formaLeitura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`formaLeitura` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`chamadoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`chamadoServico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idExterno` INT NULL DEFAULT NULL,
  `defeito` VARCHAR(150) NOT NULL,
  `dataAbertura` DATETIME NULL DEFAULT NULL,
  `dataFechamento` DATETIME NULL DEFAULT NULL,
  `dataAtendimento` DATETIME NULL,
  `tempoAtendimento` TIME NULL,
  `businessPartnerCode` VARCHAR(30) NOT NULL,
  `contato` VARCHAR(150) NOT NULL,
  `status` INT NOT NULL,
  `tipo` INT NOT NULL,
  `abertoPor` INT NOT NULL,
  `tecnico` INT NOT NULL,
  `prioridade` INT NOT NULL,
  `cartaoEquipamento` INT NOT NULL,
  `modelo` VARCHAR(120) NOT NULL,
  `fabricante` VARCHAR(60) NOT NULL,
  `observacaoTecnica` VARCHAR(420) NOT NULL,
  `sintoma` VARCHAR(420) NOT NULL,
  `causa` VARCHAR(420) NOT NULL,
  `acao` VARCHAR(420) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`pedidoConsumivel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`pedidoConsumivel` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigoCartaoEquipamento` INT NOT NULL,
  `data` DATETIME NOT NULL,
  `status` INT NOT NULL,
  `observacao` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`leitura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`leitura` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigoCartaoEquipamento` INT NOT NULL,
  `chamadoServico_id` INT NULL,
  `consumivel_id` INT NULL,
  `data` DATETIME NOT NULL,
  `contador_id` INT NOT NULL,
  `contagem` DECIMAL NOT NULL,
  `ajusteContagem` DECIMAL NOT NULL,
  `assinaturaDatacopy` INT NULL,
  `assinaturaCliente` VARCHAR(45) NULL,
  `obs` LONGTEXT NULL DEFAULT NULL,
  `origemLeitura_id` INT NOT NULL,
  `formaLeitura_id` INT NOT NULL,
  `reset` TINYINT(1) NOT NULL,
  INDEX `fk_itens_has_contador_contador1_idx` (`contador_id` ASC),
  INDEX `fk_leitura_origemLeitura1_idx` (`origemLeitura_id` ASC),
  PRIMARY KEY (`id`),
  INDEX `fk_leitura_formaLeitura1_idx` (`formaLeitura_id` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_leitura_chamadoServico1_idx` (`chamadoServico_id` ASC),
  INDEX `fk_leitura_consumivel1_idx` (`consumivel_id` ASC),
  CONSTRAINT `fk_itens_has_contador_contador1`
    FOREIGN KEY (`contador_id`)
    REFERENCES `addOnContratos`.`contador` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leitura_origemLeitura1`
    FOREIGN KEY (`origemLeitura_id`)
    REFERENCES `addOnContratos`.`origemLeitura` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leitura_formaLeitura1`
    FOREIGN KEY (`formaLeitura_id`)
    REFERENCES `addOnContratos`.`formaLeitura` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leitura_chamadoServico1`
    FOREIGN KEY (`chamadoServico_id`)
    REFERENCES `addOnContratos`.`chamadoServico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leitura_consumivel1`
    FOREIGN KEY (`consumivel_id`)
    REFERENCES `addOnContratos`.`pedidoConsumivel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`tipoInsumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`tipoInsumo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipoInsumo` VARCHAR(80) NOT NULL,
  `unidadeMedida` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`insumo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(120) NOT NULL,
  `tipoInsumo` INT NOT NULL,
  `valor` FLOAT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_tipoInsumo_idx` (`tipoInsumo` ASC),
  CONSTRAINT `fk_insumo_tipo`
    FOREIGN KEY (`tipoInsumo`)
    REFERENCES `addOnContratos`.`tipoInsumo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`despesaChamado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`despesaChamado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigoChamado` INT NOT NULL,
  `codigoInsumo` INT NULL,
  `codigoItem` VARCHAR(40) NOT NULL,
  `nomeItem` VARCHAR(200) NOT NULL,
  `quantidade` INT NOT NULL,
  `medicaoInicial` FLOAT NOT NULL,
  `medicaoFinal` FLOAT NOT NULL,
  `totalDespesa` FLOAT NOT NULL,
  `observacao` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_despesa_chamado_idx` (`codigoChamado` ASC),
  INDEX `fk_despesa_insumo_idx` (`codigoInsumo` ASC),
  CONSTRAINT `fk_despesa_chamado`
    FOREIGN KEY (`codigoChamado`)
    REFERENCES `addOnContratos`.`chamadoServico` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_despesa_insumo`
    FOREIGN KEY (`codigoInsumo`)
    REFERENCES `addOnContratos`.`insumo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`smtpServer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`smtpServer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `endereco` VARCHAR(100) NOT NULL,
  `porta` INT NOT NULL,
  `usuario` VARCHAR(100) NOT NULL,
  `senha` VARCHAR(100) NOT NULL,
  `requiresTLS` TINYINT(1) NOT NULL,
  `defaultServer` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`mailing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`mailing` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `businessPartnerCode` VARCHAR(30) NOT NULL,
  `businessPartnerName` VARCHAR(200) NOT NULL,
  `contrato_id` INT NOT NULL,
  `subContrato_id` INT NOT NULL,
  `diaFaturamento` INT NOT NULL,
  `destinatarios` VARCHAR(250) NOT NULL,
  `enviarDemonstrativo` TINYINT(1) NOT NULL DEFAULT 0,
  `ultimoEnvio` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `compositeIndex_UNIQUE` (`businessPartnerCode` ASC, `contrato_id` ASC, `subContrato_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`faturamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`faturamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `businessPartnerCode` VARCHAR(30) NOT NULL,
  `businessPartnerName` VARCHAR(200) NOT NULL,
  `mailing_id` INT NOT NULL,
  `dataInicial` DATETIME NOT NULL,
  `dataFinal` DATETIME NOT NULL,
  `mesReferencia` INT NOT NULL,
  `anoReferencia` INT NOT NULL,
  `multaRecisoria` FLOAT NOT NULL,
  `acrescimoDesconto` FLOAT NOT NULL,
  `total` FLOAT NOT NULL,
  `obs` LONGTEXT NOT NULL,
  `incluirRelatorio` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_faturamento_mailing_idx` (`mailing_id` ASC),
  CONSTRAINT `fk_faturamento_mailing`
    FOREIGN KEY (`mailing_id`)
    REFERENCES `addOnContratos`.`mailing` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`pedidoPecaReposicao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`pedidoPecaReposicao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `chamadoServico_id` INT NOT NULL,
  `data` DATETIME NOT NULL,
  `destinatarios` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_pedidoPecas_chamado_idx` (`chamadoServico_id` ASC),
  CONSTRAINT `fk_pedidoPeca_chamado`
    FOREIGN KEY (`chamadoServico_id`)
    REFERENCES `addOnContratos`.`chamadoServico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`solicitacaoItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`solicitacaoItem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pedidoConsumivel_id` INT NULL,
  `pedidoPecaReposicao_id` INT NULL,
  `codigoItem` VARCHAR(40) NOT NULL,
  `nomeItem` VARCHAR(200) NOT NULL,
  `quantidade` INT NOT NULL,
  `total` FLOAT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_item_pedidoConsumivel_idx` (`pedidoConsumivel_id` ASC),
  INDEX `fk_item_pedidoPecaReposicao_idx` (`pedidoPecaReposicao_id` ASC),
  CONSTRAINT `fk_item_pedidoConsumivel`
    FOREIGN KEY (`pedidoConsumivel_id`)
    REFERENCES `addOnContratos`.`pedidoConsumivel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_pedidoPecaReposicao`
    FOREIGN KEY (`pedidoPecaReposicao_id`)
    REFERENCES `addOnContratos`.`pedidoPecaReposicao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`custoIndireto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`custoIndireto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `solicitante` INT NOT NULL,
  `infoSolicitante` VARCHAR(120) NOT NULL,
  `codigoInsumo` INT NOT NULL,
  `medicaoInicial` FLOAT NOT NULL,
  `medicaoFinal` FLOAT NOT NULL,
  `total` FLOAT NOT NULL,
  `observacao` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_custoIndireto_insumo_idx` (`codigoInsumo` ASC),
  CONSTRAINT `fk_custoIndireto_insumo`
    FOREIGN KEY (`codigoInsumo`)
    REFERENCES `addOnContratos`.`insumo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`despesaDistribuida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`despesaDistribuida` (
  `chamadoServico_id` INT NOT NULL,
  `custoIndireto_id` INT NOT NULL,
  PRIMARY KEY (`chamadoServico_id`, `custoIndireto_id`),
  INDEX `fk_despesaDistribuida_chamado_idx` (`chamadoServico_id` ASC),
  INDEX `fk_despesaDistribuida_custoIndireto_idx` (`custoIndireto_id` ASC),
  CONSTRAINT `fk_despesaDistribuida_chamado`
    FOREIGN KEY (`chamadoServico_id`)
    REFERENCES `addOnContratos`.`chamadoServico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_despesaDistribuida_custoIndireto`
    FOREIGN KEY (`custoIndireto_id`)
    REFERENCES `addOnContratos`.`custoIndireto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`funcionalidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`funcionalidade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`autorizacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`autorizacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `login_id` INT NOT NULL,
  `funcionalidade` INT NOT NULL,
  `nivelAutorizacao` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_autorizacao_login_idx` (`login_id` ASC),
  INDEX `fk_autorizacao_funcionalidade_idx` (`funcionalidade` ASC),
  CONSTRAINT `fk_autorizacao_login`
    FOREIGN KEY (`login_id`)
    REFERENCES `addOnContratos`.`login` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_autorizacao_funcionalidade`
    FOREIGN KEY (`funcionalidade`)
    REFERENCES `addOnContratos`.`funcionalidade` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`config`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`config` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nomeParametro` VARCHAR(80) NOT NULL,
  `descricao` VARCHAR(120) NOT NULL,
  `tipoParametro` INT NOT NULL,
  `valor` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`itemFaturamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`itemFaturamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigoFaturamento` INT NOT NULL,
  `contrato_id` INT NOT NULL,
  `subContrato_id` INT NOT NULL,
  `codigoCartaoEquipamento` INT NOT NULL,
  `tipoLocacao` VARCHAR(120) NOT NULL,
  `counterId` INT NOT NULL,
  `dataLeitura` DATETIME NOT NULL,
  `medicaoFinal` DECIMAL NOT NULL,
  `medicaoInicial` DECIMAL NOT NULL,
  `consumo` DECIMAL NOT NULL,
  `ajuste` DECIMAL NOT NULL,
  `franquia` DECIMAL(16,6) NOT NULL,
  `excedente` DECIMAL NOT NULL,
  `tarifaSobreExcedente` FLOAT NOT NULL,
  `fixo` FLOAT NOT NULL,
  `variavel` FLOAT NOT NULL,
  `total` FLOAT NOT NULL,
  `acrescimoDesconto` FLOAT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_item_faturamento_idx` (`codigoFaturamento` ASC),
  CONSTRAINT `fk_item_faturamento`
    FOREIGN KEY (`codigoFaturamento`)
    REFERENCES `addOnContratos`.`faturamento` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`reajusteContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`reajusteContrato` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `contrato_id` INT NOT NULL,
  `data` DATETIME NOT NULL,
  `indiceUtilizado` VARCHAR(120) NOT NULL,
  `aliquotaUtilizada` FLOAT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_reajuste_idx` (`contrato_id` ASC),
  CONSTRAINT `fk_reajuste`
    FOREIGN KEY (`contrato_id`)
    REFERENCES `addOnContratos`.`contrato` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`modeloEquipamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`modeloEquipamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `modelo` VARCHAR(120) NOT NULL,
  `fabricante` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `modelo_UNIQUE` (`modelo` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`regraComissaoVolume`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`regraComissaoVolume` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `categoriaContrato` INT NOT NULL,
  `quantContratosDe` INT NOT NULL,
  `quantContratosAte` INT NOT NULL,
  `valorFaturamentoDe` DOUBLE NOT NULL,
  `valorFaturamentoAte` DOUBLE NOT NULL,
  `comissao` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`regraComissaoAssinatura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`regraComissaoAssinatura` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `segmento` INT NOT NULL,
  `dataAssinaturaDe` DATETIME NOT NULL,
  `dataAssinaturaAte` DATETIME NOT NULL,
  `comissao` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`ativoFixo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`ativoFixo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `businessPartnerCode` VARCHAR(30) NOT NULL,
  `businessPartnerName` VARCHAR(200) NOT NULL,
  `codigoCartaoEquipamento` INT NOT NULL,
  `codigoItem` VARCHAR(40) NOT NULL,
  `descricao` VARCHAR(200) NOT NULL,
  `valorAquisicao` FLOAT NOT NULL,
  `dataInstalacao` DATETIME NOT NULL,
  `vidaUtil` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`depreciacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`depreciacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ativo` INT NOT NULL,
  `mesReferencia` INT NOT NULL,
  `anoReferencia` INT NOT NULL,
  `intensidadeDesgaste` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_depreciacao_ativo_idx` (`ativo` ASC),
  CONSTRAINT `fk_depreciacao_ativo`
    FOREIGN KEY (`ativo`)
    REFERENCES `addOnContratos`.`ativoFixo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `addOnContratos`.`estatisticaAtendimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addOnContratos`.`estatisticaAtendimento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mesReferencia` INT NOT NULL,
  `anoReferencia` INT NOT NULL,
  `quantidadeChamados` INT NOT NULL,
  `tempoEmAtendimento` TIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `addOnContratos`.`indicesReajuste`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`indicesReajuste` (`id`, `sigla`, `nome`, `aliquota`) VALUES (1, 'Nenhum', 'Nenhum', 0);
INSERT INTO `addOnContratos`.`indicesReajuste` (`id`, `sigla`, `nome`, `aliquota`) VALUES (2, 'IGPM', 'Índice Geral de Preços de Mercado', 5.09);
INSERT INTO `addOnContratos`.`indicesReajuste` (`id`, `sigla`, `nome`, `aliquota`) VALUES (3, 'TR', 'Taxa Referencial de Juros', 1.2079);
INSERT INTO `addOnContratos`.`indicesReajuste` (`id`, `sigla`, `nome`, `aliquota`) VALUES (4, 'INPC', 'Índice Nacional de Preços ao Consumidor', 6.07);
INSERT INTO `addOnContratos`.`indicesReajuste` (`id`, `sigla`, `nome`, `aliquota`) VALUES (5, 'IPCA', 'Índice Nacional de Preços ao Consumidor Amplo', 6.5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`tipoContrato`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (1, 'LS', 'LOCAÇÃO SIMPLES', 0);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (2, 'LSF', 'LOCAÇÃO SIMPLES P/FRANQUIA', 0);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (3, 'LSM', 'LOCAÇÃO SIMPLES P/MILHEIRO', 0);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (4, 'LPE', 'LOCAÇÃO P/PÁG. EXTRAÍDAS', 0);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (5, 'LSF-FX', 'LOCAÇÃO SIMPLES POR FAIXA DE FRANQUIA', 1);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (6, 'DATAGED', 'DATAGED', 0);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (7, 'GESTÃO TI', 'GESTÃO TI', 0);
INSERT INTO `addOnContratos`.`tipoContrato` (`id`, `sigla`, `nome`, `bonus`) VALUES (8, 'DESKTOP', 'DESKTOP', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`login`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`login` (`id`, `idExterno`, `nome`, `usuario`, `senha`, `removido`) VALUES (1, NULL, 'Administrator', 'admin', '80VvlpZi4i', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`contador`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`contador` (`id`, `nome`) VALUES (1, 'Contador Pb');
INSERT INTO `addOnContratos`.`contador` (`id`, `nome`) VALUES (2, 'Contador Cor');
INSERT INTO `addOnContratos`.`contador` (`id`, `nome`) VALUES (3, 'Contador de páginas escaneadas');
INSERT INTO `addOnContratos`.`contador` (`id`, `nome`) VALUES (4, 'Medidor de Tráfego (Megabytes)');

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`origemLeitura`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`origemLeitura` (`id`, `nome`) VALUES (1, 'Chamado de Serviço');
INSERT INTO `addOnContratos`.`origemLeitura` (`id`, `nome`) VALUES (2, 'Faturamento');
INSERT INTO `addOnContratos`.`origemLeitura` (`id`, `nome`) VALUES (3, 'Solicitação de Consumível');

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`formaLeitura`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`formaLeitura` (`id`, `nome`) VALUES (1, 'Visita ao cliente');
INSERT INTO `addOnContratos`.`formaLeitura` (`id`, `nome`) VALUES (2, 'Telefone');
INSERT INTO `addOnContratos`.`formaLeitura` (`id`, `nome`) VALUES (3, 'Email');
INSERT INTO `addOnContratos`.`formaLeitura` (`id`, `nome`) VALUES (4, 'Gerenciamento Remoto');

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`tipoInsumo`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`tipoInsumo` (`id`, `tipoInsumo`, `unidadeMedida`) VALUES (1, 'Mão de Obra', 'Hora');
INSERT INTO `addOnContratos`.`tipoInsumo` (`id`, `tipoInsumo`, `unidadeMedida`) VALUES (2, 'Combustível', 'Kilômetro');
INSERT INTO `addOnContratos`.`tipoInsumo` (`id`, `tipoInsumo`, `unidadeMedida`) VALUES (3, 'Alimentação', 'Quilograma');

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`insumo`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (1, 'Hora do técnico junior', 1, 10);
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (2, 'Hora do técnico pleno', 1, 20);
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (3, 'Hora do técnico senior', 1, 30);
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (4, 'Kilômetro percorrido no transporte de cargas', 2, 1.8);
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (5, 'Kilômetro percorrido no atendimento técnico', 2, 2.3);
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (6, 'Kilograma no restaurante novo espaço', 3, 31);
INSERT INTO `addOnContratos`.`insumo` (`id`, `descricao`, `tipoInsumo`, `valor`) VALUES (7, 'Kilograma no restaurante sideral', 3, 35);

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`smtpServer`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`smtpServer` (`id`, `nome`, `endereco`, `porta`, `usuario`, `senha`, `requiresTLS`, `defaultServer`) VALUES (1, 'Servidor gmail na porta 465', 'smtp.gmail.com', 465, 'suporte@datacopy.com.br', 'Datacopy01', 1, 1);
INSERT INTO `addOnContratos`.`smtpServer` (`id`, `nome`, `endereco`, `porta`, `usuario`, `senha`, `requiresTLS`, `defaultServer`) VALUES (2, 'Servidor gmail na porta 587', 'smtp.gmail.com', 587, 'suporte@datacopy.com.br', 'Datacopy01', 1, 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`funcionalidade`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (1, 'Administração do sistema');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (2, 'Gerenciamento de chamados');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (3, 'Gerenciamento de contratos');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (4, 'Solicitação de consumíveis');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (5, 'Gerenciamento de equipamentos e peças');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (6, 'Gerenciamento de medidores e leituras');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (7, 'Envio de Faturamento');
INSERT INTO `addOnContratos`.`funcionalidade` (`id`, `nome`) VALUES (8, 'Síntese de Faturamento');

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`autorizacao`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (1, 1, 1, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (2, 1, 2, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (3, 1, 3, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (4, 1, 4, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (5, 1, 5, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (6, 1, 6, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (7, 1, 7, 3);
INSERT INTO `addOnContratos`.`autorizacao` (`id`, `login_id`, `funcionalidade`, `nivelAutorizacao`) VALUES (8, 1, 8, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`config`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (1, 'limiteListaChamados', 'Quantidade de Chamados listados', 1, '500');
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (2, 'limiteListaConsumiveis', 'Quantidade de Solicitações de Consumíveis listadas', 1, '500');
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (3, 'limiteListaEquipamentos', 'Data de corte de equipamentos listados (instalação)', 3, '01/01/2012');
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (4, 'mesFaturamento', 'Mês referência do Faturamento', 5, '12');
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (5, 'anoFaturamento', 'Ano referência do Faturamento', 1, '2013');
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (6, 'emailPadrao', 'Contato (e-mail padrão)', 2, 'debora@datacopytrade.com.br');
INSERT INTO `addOnContratos`.`config` (`id`, `nomeParametro`, `descricao`, `tipoParametro`, `valor`) VALUES (7, 'ordenarPorSerieFabrica', 'Ordenar equipamentos por Série de Fábrica', 4, 'true');

COMMIT;


-- -----------------------------------------------------
-- Data for table `addOnContratos`.`modeloEquipamento`
-- -----------------------------------------------------
START TRANSACTION;
USE `addOnContratos`;
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (1, 'EP1030', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (2, 'EP1031', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (3, 'EP1054', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (4, 'EP2030', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (5, 'EP2080', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (6, 'EP4000', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (7, 'EP6001', 4);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (8, 'DCP7040', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (9, 'DCP7840', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (10, 'DCP8060', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (11, 'DCP8065DN', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (12, 'DCP8085DN', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (13, 'DCP9045CDN', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (14, 'MFC7440N', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (15, 'MFC8820D', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (16, 'MFC8840DN', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (17, 'MFC8860DN', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (18, 'MFC8890DN', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (19, 'MFC8890DW', 5);
INSERT INTO `addOnContratos`.`modeloEquipamento` (`id`, `modelo`, `fabricante`) VALUES (20, 'MFC9840CDW', 5);

COMMIT;
