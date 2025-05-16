<?php
return [
    'indexer' => [
        'batch_size' => [
            'cataloginventory_stock' => [
                'simple' => 200
            ],
            'catalog_category_product' => 666,
            'catalogsearch_fulltext' => [
                'partial_reindex' => 100,
                'mysql_get' => 500,
                'elastic_save' => 500
            ],
            'catalog_product_price' => [
                'simple' => 200,
                'default' => 500,
                'configurable' => 666
            ],
            'catalogpermissions_category' => 999,
            'inventory' => [
                'simple' => 210,
                'default' => 510,
                'configurable' => 616
            ]
        ]
    ]
];
