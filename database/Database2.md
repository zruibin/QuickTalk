

####表字段

**t_user**

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


**t_user_auth**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| password | |
| token | |
| QQ | |
| wechat | |
| weibo | |


**t_user_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| other_user_uuid | |


**t_user_setting**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| status | |
| other_user_uuid | |


**t_user_eduction**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| order | |
| school | |
| begin_time | |
| end_time | |
| major | |


**t_project**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| uuid | |
| title | |
| detail | |
| result | |
| author | |
| time | |
| like | |
| status | |


**t_project_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project_uuid | |
| member_uuid | |
| time | | 


**t_project_media**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project_uuid | |
| order | |
| type | |
| path | |
| time | |


**t_project_plan**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project_uuid | |
| order | |
| content | |
| excution_time | |


**t_comment**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project_uuid | |
| user_uuid | |
| content | |
| time | |
| like | |
| is_reply | |
| reply_user_uuid  | |


**t_project_journal**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| uuid | |
| project_uuid | |
| user_uuid | |
| content | |
| time | |
| like | |

**t_project_journal_media**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| journal_uuid | |
| type | |
| order | |
| path | |
| time | |

**t_message_like**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t_message_project**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t_message_membership**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t_message_start**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| type | |
| content_uuid | |
| time | |
| owner_uuid | |
| status | |
| content | |

**t_tag_user**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| user_uuid | |
| order | |
| type | |
| content | |

**t_tag_project**

| 字段 | 说明 |
| ---- | ---- |
| ID | |
| project_uuid | |
| order | |
| type | |
| content | |



----


```
 ID物理主键+UUID逻辑主键
 
InnoDB不适合使用UUID做物理主键，可以把它作为逻辑主键，物理主键依然使用自增ID。

主键仍然用auto_increment_int来做，而另加一个uuid做唯一索引，表外键关联什么的，还 用uuid来做，
也就是说auto_increment_int只是一个形式上的主键，而uuid才是事实上的主键，这样，一方面int主键不会浪费太多空间，
另一方面，还可以继续使用uuid。

 

优点：

InnoDB会对主键进行物理排序，这对auto_increment_int类型有好处，因为后一次插入的主键位置总是在最后。
但是对uuid来说则有缺点，因为uuid是杂乱无章的，每次插入的主键位置是不确定的，可能在开头，也可能在中间，
在进行主键物理排序的时候，势必会造成大量的 IO操作影响效率。

 

缺点：

同自增ID的缺点：全局值加锁解锁以保证增量的唯一性带来的性能问题。
```



