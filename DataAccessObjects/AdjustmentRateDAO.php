<?php

class AdjustmentRateDAO{

    var $mysqlConnection;
    var $showErrors;

    #construtor
    function AdjustmentRateDAO($mysqlConnection){
        $this->mysqlConnection = $mysqlConnection;
        $this->showErrors = 0;
    }

    function StoreRecord($dto){
        // Monta a query dependendo do id como INSERT ou UPDATE
        $query = "INSERT INTO indicesReajuste VALUES (NULL, '".$dto->sigla."', '".$dto->nome."', ".$dto->aliquota.");";
        if ($dto->id > 0)
            $query = "UPDATE indicesReajuste SET sigla = '".$dto->sigla."', nome = '".$dto->nome."', aliquota = ".$dto->aliquota." WHERE id = ".$dto->id.";";

        $result = mysql_query($query, $this->mysqlConnection);
        if ($result) {
            $insertId = mysql_insert_id($this->mysqlConnection);
            if ($insertId == null) return $dto->id;
            return $insertId;
        }

        if ((!$result) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/>';
        }
        return null;
    }

    function DeleteRecord($id){
        $query = "DELETE FROM indicesReajuste WHERE id = ".$id;
        $result = mysql_query($query, $this->mysqlConnection);

        if ((!$result) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/>';
        }
        return $result;
    }

    function RetrieveRecord($id){
        $dto = null;

        $query = "SELECT * FROM indicesReajuste WHERE id = ".$id;
        $recordSet = mysql_query($query, $this->mysqlConnection);
        if ((!$recordSet) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/><br/>';
        }
        $recordCount = mysql_num_rows($recordSet);
        if ($recordCount != 1) return null;

        $record = mysql_fetch_array($recordSet);
        if (!$record) return null;
        $dto = new AdjustmentRateDTO();
        $dto->id       = $record['id'];
        $dto->sigla     = $record['sigla'];
        $dto->nome      = $record['nome'];
        $dto->aliquota  = $record['aliquota'];
        mysql_free_result($recordSet);

        return $dto;
    }

    function RetrieveRecordArray($filter = null){
        $dtoArray = array();

        $query = "SELECT * FROM indicesReajuste WHERE ".$filter;
        if (empty($filter)) $query = "SELECT * FROM indicesReajuste";

        $recordSet = mysql_query($query, $this->mysqlConnection);
        if ((!$recordSet) && ($this->showErrors)) {
            print_r(mysql_error());
            echo '<br/><br/>';
        }
        $recordCount = mysql_num_rows($recordSet);
        if ($recordCount == 0) return $dtoArray;

        $index = 0;
        while( $record = mysql_fetch_array($recordSet) ){
            $dto = new AdjustmentRateDTO();
            $dto->id        = $record['id'];
            $dto->sigla     = $record['sigla'];
            $dto->nome      = $record['nome'];
            $dto->aliquota  = $record['aliquota'];

            $dtoArray[$index] = $dto;
            $index++;
        }
        mysql_free_result($recordSet);

        return $dtoArray;
    }

    static function GetAlias($mysqlConnection, $id){
        $alias = "";

        $adjustmentRateDAO = new AdjustmentRateDAO($mysqlConnection);
        $adjustmentRateDAO->showErrors = 1;
        $adjustmentRate = $adjustmentRateDAO->RetrieveRecord($id);
        if ($adjustmentRate != null) $alias = $adjustmentRate->sigla;

        return $alias;
    }
}

?>
