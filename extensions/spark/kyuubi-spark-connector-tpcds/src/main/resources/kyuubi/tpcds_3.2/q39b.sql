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
-- q39b --
with inv as (
  select
    w_warehouse_name,
    w_warehouse_sk,
    i_item_sk,
    d_moy,
    stdev,
    mean,
    case
      mean
      when 0 then null
      else stdev / mean
    end cov
  from
    (
      select
        w_warehouse_name,
        w_warehouse_sk,
        i_item_sk,
        d_moy,
        stddev_samp(inv_quantity_on_hand) stdev,
        avg(inv_quantity_on_hand) mean
      from
        inventory,
        item,
        warehouse,
        date_dim
      where
        inv_item_sk = i_item_sk
        and inv_warehouse_sk = w_warehouse_sk
        and inv_date_sk = d_date_sk
        and d_year = 1998
      group by
        w_warehouse_name,
        w_warehouse_sk,
        i_item_sk,
        d_moy
    ) foo
  where
    case
      mean
      when 0 then 0
      else stdev / mean
    end > 1
)
select
  inv1.w_warehouse_sk,
  inv1.i_item_sk,
  inv1.d_moy,
  inv1.mean,
  inv1.cov,
  inv2.w_warehouse_sk,
  inv2.i_item_sk,
  inv2.d_moy,
  inv2.mean,
  inv2.cov
from
  inv inv1,
  inv inv2
where
  inv1.i_item_sk = inv2.i_item_sk
  and inv1.w_warehouse_sk = inv2.w_warehouse_sk
  and inv1.d_moy = 4
  and inv2.d_moy = 4 + 1
  and inv1.cov > 1.5
order by
  inv1.w_warehouse_sk,
  inv1.i_item_sk,
  inv1.d_moy,
  inv1.mean,
  inv1.cov,
  inv2.d_moy,
  inv2.mean,
  inv2.cov;
