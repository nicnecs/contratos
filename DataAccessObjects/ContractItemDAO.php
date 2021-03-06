<?php

class ContractItemDAO{

    var $mysqlConnection;
    var $showErrors;

    #construtor
    function ContractItemDAO($mysqlConnection){
        $this->mysqlConnection = $mysqlConnection;
        $this->showErrors = 0;
    }

    function StoreRecord($dto){
        // Monta a query
        $query = "INSERT INTO itens VALUES (".$dto->codigoCartaoEquipamento.", '".$dto->businessPartnerCode."', ".$dto->codigoContrato.", ".$dto->codigoSubContrato.");";

        $result = mysql_query($query, $this->mysqlConnection);
        if ($result) {
            $insertId = mysql_insert_id($this->mysqlConnection);
            if ($insertId == null) return $dto->codigoCartaoEquipamento;
            return $insertId;
        }

        if ((!$result) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/>';
        }
        return null;
    }

    function DeleteRecord($equipmentCode){
        $query = "DELETE FROM itens WHERE codigoCartaoEquipamento = ".$equipmentCode;
        $result = mysql_query($query, $this->mysqlConnection);

        if ((!$result) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/>';
        }
        return $result;
    }

    function RetrieveRecord($equipmentCode){
        $dto = null;

        $query = "SELECT * FROM itens WHERE codigoCartaoEquipamento = ".$equipmentCode;
        $recordSet = mysql_query($query, $this->mysqlConnection);
        if ((!$recordSet) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/><br/>';
        }
        $recordCount = mysql_num_rows($recordSet);
        if ($recordCount != 1) return null;

        $record = mysql_fetch_array($recordSet);
        if (!$record) return null;
        $dto = new ContractItemDTO();
        $dto->codigoCartaoEquipamento = $record['codigoCartaoEquipamento'];
        $dto->businessPartnerCode = $record['businessPartnerCode'];
        $dto->codigoContrato = $record['contrato_id'];
        $dto->codigoSubContrato = $record['subContrato_id'];
        mysql_free_result($recordSet);

        return $dto;
    }

    function RetrieveRecordArray($filter = null){
        $dtoArray = array();

        $query = "SELECT * FROM itens WHERE ".$filter;
        if (empty($filter)) $query = "SELECT * FROM itens";

        $recordSet = mysql_query($query, $this->mysqlConnection);
        if ((!$recordSet) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/><br/>';
        }
        $recordCount = mysql_num_rows($recordSet);
        if ($recordCount == 0) return $dtoArray;

        $index = 0;
        while( $record = mysql_fetch_array($recordSet) ){
            $dto = new ContractItemDTO();
            $dto->codigoCartaoEquipamento = $record['codigoCartaoEquipamento'];
            $dto->businessPartnerCode = $record['businessPartnerCode'];
            $dto->codigoContrato = $record['contrato_id'];
            $dto->codigoSubContrato = $record['subContrato_id'];

            $dtoArray[$index] = $dto;
            $index++;
        }
        mysql_free_result($recordSet);

        return $dtoArray;
    }

    // Obtem um array de itens pertencentes aos subcontratos informados
    static function GetItemsByOwner($mysqlConnection, $subContractEnumeration) {
        $contractItemDAO = new ContractItemDAO($mysqlConnection);
        $contractItemDAO->showErrors = 1;
        $itemArray = $contractItemDAO->RetrieveRecordArray("subContrato_id IN (".$subContractEnumeration.")");

        return $itemArray;
    }

}

?>
