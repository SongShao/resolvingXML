//
//  ViewController.m
//  resolvingXML
//
//  Created by lst on 16/7/9.
//  Copyright © 2016年 lst. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "GDataXMLNode.h"

@interface ViewController ()<NSXMLParserDelegate>
@property (nonatomic, retain) NSMutableArray *personArray;
//创建内容接收遇到的文本内容
@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//SAX 解析方式
/**
 *优点:逐行解析,遇到错误立即停止,避免全部解析后的那修改问题,苹果原生不用导入框架
 *
 *缺点:解析过程慢
 */
/**SAX 解析全过程
 1.获取到 XML 路径 url
 2.创建解析器 nsxmlparser
 3.设置解析器代理   解析方法在代理方法内部
 4.开始解析  解析器  parse
 
 //解析方法   
 1.开始解析      //开始解析文档,先初始化数组 (声明数组属性)
 2.遇到开始标签  //创建所属类(先要创建这个类,声明这个类属性)
 3.遇到解析内容  //声明属性,接收文本
 4.遇到结束标签  //给类的属性赋值,最后将类添加到数组中
 5.解析已经结束  //可以遍历数组,打印对象
 */

- (IBAction)SAXresolving:(id)sender
{
    //获取 xml 文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"person.xml" ofType:nil];
    //将本地路径转化成 URL
    NSURL *url = [[NSURL alloc]initFileURLWithPath:filePath];
    //创建 xml 解析器
    NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    //设置代理 (解析方法在代理方法里)
    parser.delegate = self;
    //开始解析
    [parser parse];
}
//DOM 解析方式
- (IBAction)DOMresolving:(id)sender
{
    //获取内容
    //获取 xml 文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"person.xml" ofType:nil];
   //读取内容
    NSError *error = nil;
    NSString *content= [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        NSLog(@"%@",content);
    }else{
        NSLog(@"%@",error);
    }
    //创建解析器
    GDataXMLDocument *docment = [[GDataXMLDocument alloc]initWithXMLString:content options:0 error:nil];
    //找到根节点
    GDataXMLElement *rootElement = [docment rootElement];
    
    //找到子节点
    NSArray *personElements = [rootElement elementsForName:@"Person"];
    for (GDataXMLElement *element in personElements) {
//        NSLog(@"%@",element);
        //创建人类
        Person *person = [[Person alloc] init];
        person.name = [[[element elementsForName:@"name"]firstObject]stringValue];
        person.age = [[[element elementsForName:@"age"]firstObject] stringValue];
        person.height = [[[element elementsForName:@"height"]firstObject]stringValue];
        
        [self.personArray addObject:person];
    }
    NSLog(@"%@",self.personArray);
//    NSLog(@"%@",personElements);
    
}


#pragma mark -NSXMLParserDelegate
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser;{
    NSLog(@"开始解析");
    //开始解析文档,先初始化数组
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    
}
//结束解析
- (void)parserDidEndDocument:(NSXMLParser *)parser;{
    NSLog(@"已经结束解析");
    //结束 验证解析结果  遍历数组打印对象
    for (Person *person in self.personArray) {
        NSLog(@"%@",person);
    }
}
//遇到开始标签
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict;{
    NSLog(@"遇到开始标签 %@",elementName);
    if ([elementName isEqualToString:@"Person"]) {
        self.person = [[Person alloc] init];
        
    }
}
//遇到结束标签
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName;{
    NSLog(@"遇到结束标签 %@",elementName);
    if ([elementName isEqualToString:@"name"]){
        self.person.name = self.string;
    }else if ([elementName isEqualToString:@"age"]){
        self.person.age = self.string;
    }else if ([elementName isEqualToString:@"height"]){
        self.person.height = self.string;
    } else if ([elementName isEqualToString:@"Person"]){
        [self.personArray addObject:self.person];
    }
        

}
//遇到字符串(内容)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    NSLog(@"%@",string);
    self.string = string;
}
@end
