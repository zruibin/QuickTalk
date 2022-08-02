

####表字段

**t\_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| uuid | |
| nickname | |
| detail | |
| phone | |
| QQ | |
| wechat | |
| email | |
| gender | |
| area | |
| avatar | |
| career | |
| time | |


**t\_user_auth**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| password | |
| token | |
| QQ | |
| wechat | |
| weibo | |


**t\_user_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| other_user_uuid | |


**t\_user_setting**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| status | |
| other_user_uuid | |


**t\_user_eduction**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| order | |
| school | |
| begin_time | |
| end_time | |
| major | |


**t\_project**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| uuid | |
| title | |
| detail | |
| result | |
| author_uuid | |
| time | |
| like | |
| status | |


**t\_project\_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project\_uuid | |
| member_uuid | |
| time | | 


**t\_project\_media**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project\_uuid | |
| order | |
| type | |
| media_name | |
| time | |


**t\_project\_plan**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project\_uuid | |
| order | |
| content | |
| excution_time | |


**t\_comment**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project\_uuid | |
| user_uuid | |
| content | |
| time | |
| like | |
| is_reply | |
| reply_user_uuid  | |
| reply_comment\_id | |


**t\_project\_journal**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| uuid | |
| project\_uuid | |
| user_uuid | |
| content | |
| time | |
| like | |

**t\_project\_journal_media**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| journal_uuid | |
| type | |
| order | |
| path | |
| time | |

**t\_message_like**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content\_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t\_message_project**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content\_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t\_message_comment**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content\_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t\_message_start**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content\_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t\_message_contact**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content\_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t\_tag_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| order | |
| type | |
| content | |

**t\_tag_project**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project\_uuid | |
| order | |
| type | |
| content | |



----


```
 ID物理主键+UUID逻辑主键
 
InnoDB不适合使用UUID做物理主键，可以把它作为逻辑主键，物理主键依然使用自增ID。

主键仍然用auto_increment\_int来做，而另加一个uuid做唯一索引，表外键关联什么的，还 用uuid来做，
也就是说auto_increment\_int只是一个形式上的主键，而uuid才是事实上的主键，这样，一方面int主键不会浪费太多空间，
另一方面，还可以继续使用uuid。

 

优点：

InnoDB会对主键进行物理排序，这对auto_increment\_int类型有好处，因为后一次插入的主键位置总是在最后。
但是对uuid来说则有缺点，因为uuid是杂乱无章的，每次插入的主键位置是不确定的，可能在开头，也可能在中间，
在进行主键物理排序的时候，势必会造成大量的 IO操作影响效率。

 

缺点：

同自增ID的缺点：全局值加锁解锁以保证增量的唯一性带来的性能问题。
```



