--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- q22 --
select
  i_product_name,
  i_brand,
  i_class,
  i_category,
  avg(inv_quantity_on_hand) qoh
from
  inventory,
  date_dim,
  item
where
  inv_date_sk = d_date_sk
  and inv_item_sk = i_item_sk
  and d_month_seq between 1212
  and 1212 + 11
group by
  rollup (
    i_product_name,
    i_brand,
    i_class,
    i_category
  )
order by
  qoh,
  i_product_name,
  i_brand,
  i_class,
  i_category
limit
  100;
