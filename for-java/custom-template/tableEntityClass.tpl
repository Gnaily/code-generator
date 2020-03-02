@list{
package @|package|;
@;在这下面可以填import信息
import lombok.*;
import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;

import java.math.BigDecimal;
import java.util.Date;
}

/**
 * @|comment|
 * @"@"author: @|author|
 */
@|anotation|

@"@"Data
@"@"NoArgsConstructor
@"@"AllArgsConstructor
@"@"Builder
@"@"TableName("@|name|")
public class @|name|{
  @|fields|
  @|methods|
}