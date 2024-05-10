-- 调用存储过程并直接使用用户定义的变量来接收输出
CALL updateReaderID('R006', 'R999', @output_info);

-- 查看输出信息
SELECT @output_info AS Result;
