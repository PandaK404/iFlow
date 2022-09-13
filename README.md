# User Guide of iFlow
## Prerequisites

The script supports Ubuntu 20.04. It is not recommended to use the version below 20.04.

### install dependencies

Tools
  * build-essential 12.8
  * cmake 3.16.3
  * clang 10.0
  * bison 3.5.1
  * flex 2.6.4
  * swig 4.0
  * klayout 0.26

Library
  * libeigen3-dev 3.3.7-2
  * libboost-all-dev 1.71.0
  * libffi-dev 3.3-4
  * libreadline-dev 8.0-4
  * libspdlog-dev 1.5.0
  * lemon 1.3.1

## 一、Build iFlow
```
git clone https://github.com/PCNL-EDA/iFlow.git   //构建iFlow目录结构
cd iFlow
```

不使用代理下载
```
./build_iflow.sh                                  //运行脚本下载EDA工具
```

使用代理下载，代理可自定义。例如代理为hub.fastgit.xyz
```
./build_iflow.sh -mirror hub.fastgit.xyz          //运行脚本下载EDA工具
```

完成后即可使用iFlow。

## 二、iFlow目录结构
### 1、foundry/
存放工艺库，按不同工艺命名，包括lef、lib、Verilog(instance仿真用)和gds等库文件。
### 2、log/
存放flow每一步产生的log，命名格式为$design.$step.$tools.$track(eg. HD/uHD).$corner(eg. MAX/MIN).$version.log。
### 3、report/
存放每一步输出的报告，文件夹命名格式类似为$design.$step.$tools.$track(eg. HD/uHD).$corner(eg. MAX/MIN).$version。
### 4、result/
存放每一步输出的结果，如$design.v，$design.def，$design.gds，文件夹命名格式为$design.$step.$tools.$track(eg. HD/uHD).$corner(eg. MAX/MIN).$version。
### 5、rtl/
存放design的rtl文件和sdc文件，按不同的design命名。
### 6、scripts/
　		├─cfg　           //库文件配置、工具配置、flow配置脚本存放目录
    
　		├─common　　      //对文件操作的通用脚本存放目录
    
　		├─ run_flow.py    //整个flow的运行脚本
    
　		├─ $design       //对应design每一步的脚本存放目录
### 7、tools/
存放各个工具的文件。
### 8、work/
存放跑flow过程中生成的临时文件，沿用商业工具的习惯。
### 9、build_iflow.sh
下载安装EDA工具。
### 10、README.md
iFlow使用说明。

## 三、iFlow command
### Eg.
```
run_flow.py -d aes_cipher_top -s synth -f sky130 -t HS -c TYP
```
**命令参数：**

**-d (design)：**

design name；

**-s (step)：**

flow可选step：synth、floorplan、tapcell、pdn、gplace、resize、dplace、cts、filler、groute、droute、layout；

**-p (previous step)：**

用于调用前一步的结果；

**-f (foundry)：**

工艺选择，可选：sky130；

**-t (track)：**

标准单元track选择，可选：sky130[HS HD]；

**-c (corner)：**

工艺角，可选：sky130 [TYP]；

**-v (version)：**

追加到log/result rpt的版本号；

**-l ：**

前一步的版本号。


**step command：**

synth：
```
run_flow.py -d $design -s synth -f $foundry -t $track -c $corner 
```
floorplan：
```
run_flow.py -d $design -s floorplan -f $foundry -t $track -c $corner
```
tapcell：
```
run_flow.py -d $design -s tapcell -f $foundry -t $track -c $corner
```
pdn：
```
run_flow.py -d $design -s pdn -f $foundry -t $track -c $corner
```
gplace：
```
run_flow.py -d $design -s gplace -f $foundry -t $track -c $corner
```
resize：
```
run_flow.py -d $design -s resize -f $foundry -t $track -c $corner
```
dplace：
```
run_flow.py -d $design -s dplace -f $foundry -t $track -c $corner
```
cts：
```
run_flow.py -d $design -s cts -f $foundry -t $track -c $corner
```
filler：
```
run_flow.py -d $design -s filler -f $foundry -t $track -c $corner 
```
groute：
```
run_flow.py -d $design -s groute -f $foundry -t $track -c $corner
```
droute：
```
run_flow.py -d $design -s droute -f $foundry -t $track -c $corner
```
layout：
```
run_flow.py -d $design -s layout -f $foundry -t $track -c $corner
```
iFlow还可以根据用户的需求及使用的EDA工具来自定义后端流程的步骤step，具体操作见《开源EDA流程iFlow使用示例——更换工具》篇。

## 四、iFlow顶层脚本介绍
### 1、顶层脚本
iFlow的顶层脚本为iFlow/scripts/run_flow.py，可以通过选择不同的参数，包括“design”、“step”、“prestep”、“foundry”、“track”、“corner”、“version”、“preversion”，来运行不同设计、不同步骤或不同工艺等等的流程。进入“iFlow/scripts”目录下，运行命令：
```
./run_flow.py -h
```
即可查看可设置的参数及其参数介绍，如图1所示，顶层脚本的参数设置后，通过查找配置脚本中对应的参数进行匹配，再反馈回顶层脚本，从而运行相对应的流程。

图1：

![输入图片说明](.image/%E5%9B%BE%E7%89%871.png)

### 2、配置脚本
iFlow的配置脚本目录为“iFlow/scripts/cfg”，目录下有四个脚本包括“data_def.py”、“flow_cfg.py”、“foundry_cfg.py”、“tools_cfg.py”，他们分别控制数据的定义，流程配置、工艺库配置以及工具版本的配置。
#### （1）data_def.py
这个脚本主要定义了“Foundry”、“Tools”、“Flow”三个主要参数及其属性，其中，在“Flow”参数中定义了流程所含有的步骤，如图2所示。

图2：   
![输入图片说明](.image/%E5%9B%BE%E7%89%872.png)

图2中绿框中定义了Flow中具有哪些步骤，iFlow中默认的步骤分得比较细，一共有12步，用户也可以根据自己的需求进行添加步骤或者合并步骤，并到顶层脚本中做相应的修改。图2中蓝框中配置了每一步对应使用的工具及其版本（这里的版本是我们定义的版本号，并非github中的版本号，对应的工具可在“tools_cfg.py”脚本中配置），iFlow除了综合synth及版图输出layout步骤外，其余后端物理设计步骤均使用OpenRoad工具实现，其中v2def步骤不是必须的，该步骤用于将网表转为def，OpenROAD工具也可以直接读入 .v文件（网表）。

#### （2）flow_cfg.py

这个脚本中定义了一些Flow的默认参数，如图3所示，定义了4个Flow的默认设置，例如，在运行aes_cipher_top这个设计的综合时，可以不设置工艺相关的参数，直接运行命令：
```
./run_flow.py -d aes_cipher_top -s synth
```
这时会使用默认的“foundry”、“track”、“corner”运行流程，分别为“sky130”、“HS”、“TYP”。用户可以根据需求进行自定义，或者在运行“run_flow.py”脚本时设定相应的参数。在运行不同设计的流程时，顶层脚本会根据设计名在“iFlow/scripts”目录下查找以设计顶层module名一致的目录，读取相应步骤的脚本，如图4所示，在“iFlow/scripts/aes_cipher_top”目录下有不同步骤及不同工具版本的tcl脚本。

图3：

![输入图片说明](.image/%E5%9B%BE%E7%89%873.png)


图4：

![输入图片说明](.image/%E5%9B%BE%E7%89%874.png)

#### （3）foundry_cfg.py

这个脚本中定义了不同工艺节点的库文件路径，运行流程时会根据所选择的工艺节点“foundry”参数，到这个脚本里找到对应工艺节点的库文件路径进行读取。如图5所示，为sky130工艺的库文件配置，包含了“name”、“lib”、“lef”、“gds”四个属性，运行流程时，会根据不同的track和corner选择读入哪些库文件。sky130中默认只配置了TYP一种corner，也只有一种corner，对于其他含有多个corner的工艺库，用户可以根据需要，添加其它corner的lib库，以及添加需要的sram的lib库、lef库和gds库。

图5：

![输入图片说明](.image/%E5%9B%BE%E7%89%875.png)

#### （4）tools_cfg.py

这个脚本用于配置每一步使用哪种开源EDA工具及其对应的版本号，如图6所示，这里配置了三种不同版本的OpenRoad工具，OpenROAD的1.2.0版本更新之后相关的命令和1.1.0版本有一定的差别，iFlow默认使用1.1.0版本的OpenROAD，只提供了1.1.0版本的脚本，想尝试别的版本可到OpenROAD的git hub地址（https://github.com/The-OpenROAD-Project/OpenROAD）去了解相关命令。为了方便可以在“data_def.py”脚本中定义每一步使用的默认工具，也可以用命令指定使用工具的版本，例如：
```
./run_flow.py -d aes_cipher_top -s floorplan=openroad_1.1.0
```
运行此命令指定使用1.1.0版本的OpenRoad工具进行floorplan。此外，iFlow还配置了iEDA点工具，也可以尝试使用iEDA的工具实现后端物理设计，相应的使用示例我们也会在后续更新。

图6：

![输入图片说明](.image/%E5%9B%BE%E7%89%876.png)

## 五、iFlow流程介绍
### 3、综合
iFlow使用的综合工具是yosys，版本号为4be891e8。综合的目的是将RTL代码转化为网表，在iFlow中，RTL代码放在“iFlow/rtl”中，RTL代码的目录用顶层module名称来命名。在运行综合流程之前，首先要确认综合脚本中的配置是否正确。以gcd设计为例，进入“iFlow/scripts/gcd”目录，打开综合流程相关的tcl脚本，用户需要重点关注的部分参数配置在脚本的前面，如图7所示。

图7：

![输入图片说明](.image/%E5%9B%BE%E7%89%877.png)

首先，要配置好综合需要读入的库文件，例如blackbox的verilog文件和map文件等等，然后，还需要对一些综合时要用到的特定的cell也要在这里进行配置，包括tie cell和buffer。最后，还需要配置RTL代码所在的路径。

图8：

![输入图片说明](.image/%E5%9B%BE%E7%89%878.png)

综合相关的命令如图8所示，包括综合、优化以及mapping三个主要步骤，其中abc在优化时需要读入时序约束sdc文件，这个文件需要放在“iFlow/rtl”目录中对应的设计目录下，用于综合时进行时序优化。跑单步综合命令如下：
```
./run_flow.py -d gcd -s synth 
```

### 4、布局
iFlow中布局包括六个小步骤，分别为floorplan、tapcell、PDN、gplace、resize、dplace，在默认情况下，必须按照上述步骤的顺序进行流程，用户也可以根据需求通过修改顶层脚本的“-s”和“-p”参数来修改当前步骤及前一步骤。在布局规划中，目的是为了规划芯片的面积及形状，并将综合后输出的网表中所包含的instance摆放到芯片上。接下来将一一讲述布局中的各个步骤：

#### （1）floorplan

在floorplan这一步中，主要是进行芯片的面积以及形状的规划，配置参数“DIE_AREA”和“CORE_AREA”，如图9所示。

图9：

![输入图片说明](.image/%E5%9B%BE%E7%89%879.png)

在floorplan阶段，会根据工艺相关的techfile文件生成Row和Site，这里选择的Site类型为“unit”，如图10所示。此外，floorplan阶段还会生成用于走线的track，因此还需要在“iFlow/foundry/$FOUNDRY”目录下配置track对应的参数，如图11所示，sky130工艺一共有6层金属，这里对它们的走线track进行了定义。

图10：

![输入图片说明](.image/%E5%9B%BE%E7%89%8710.png)

图11：

![输入图片说明](.image/%E5%9B%BE%E7%89%8711.png)

完成了参数的配置后，需要进行floorplan的初始化，生成相应的Die、Core及Row等等，OpenRoad的floorplan初始化有三种，可以根据设置好的策略进行初始化，可以根据设定的利用率进行初始化，还可以根据设定的“DIE_AREA”和“CORE_AREA”进行初始化，iFlow的floorplan脚本默认情况下，采用第三种，如图12红框中所示。

图12：

![输入图片说明](.image/%E5%9B%BE%E7%89%8712.png)

跑单步floorplan命令如下：
```
./run_flow.py -d gcd -s floorplan -p synth  
```

#### （2）tapcell
在floorplan初始化之后，需要在core area范围内插入tapcell，tapcell的作用是为所有标准单元的N阱和衬底提供偏置电源，在core area范围内每间隔一段距离则需要摆放一个tapcell，在tapcell这一步还需要插入endcap，主要是为了插在边界处或sram及ip周围消除不对称性，在脚本中对应的配置如图13所示，这里需要配置摆放tapcell的间距，以及tapcell和endcap选用的标准单元的类型，这些参数可以在脚本前面设置，如图14所示。

图13：

![输入图片说明](.image/%E5%9B%BE%E7%89%8713.png)

图14：

![输入图片说明](.image/%E5%9B%BE%E7%89%8714.png)

跑单步tapcell命令如下：
```
./run_flow.py -d gcd -s tapcell -p floorplan 
```

#### （3）PDN
在布局中，除了面积规划及标准单元的摆放之外，还有相当重要的一步为power plan，又称为PDN，这一步主要是构建为整个芯片供电的电源网络，一个芯片的电源网络质量直接影响整个芯片的性能。PDN这一步的脚本比较简单，只有一条简单的命令，如图15所示，与电源网络相关的配置在“pdn_$FOUNDRY.cfg”配置文件中，对于使用不同的工艺库，电源网络的构建不同。

图15：

![输入图片说明](.image/%E5%9B%BE%E7%89%8715.png)

Sky130工艺的配置文件中具体的内容如图16所示。在“pdn_sky130.cfg”配置文件中，首先要创建电源相关的net，包括“VDD”和“VSS”，如图16中红框所示，然后需要把与电源相关的pin从逻辑上连接到“VDD”和“VSS”两个net上，如图16中绿框所示，最后是构建电源网络的power stripe，在这个工艺下，构建了用于标准单元供电的met1 power rail和met4、met5的power stripe，如图16中橙框所示。此外，在含有macro的设计中，我们还需要将marco中的电源连接到芯片的电源网络上，从而为marco供电。

图16：

![输入图片说明](.image/%E5%9B%BE%E7%89%8716.png)

跑单步pdn命令如下：
```
./run_flow.py -d gcd -s pdn -p tapcell 
```

#### （4）gplace
在完成电源网络的构建后，接下来需要将标准单元摆放到core area范围中，这一步即为gplace，又称为global place。在gplace阶段，需要配置的主要参数有两个，如图17所示，一个为线RC参数的抽取层，主要是为了在gplace阶段抽
取线RC参数进行延时的评估，从而更好地优化标准单元的摆放位置；另一个为“PLACE_DENSITY”，这一参数是用于设置摆放标准单元时的密度，即标准单元摆放的紧密程度。

图17：

![输入图片说明](.image/%E5%9B%BE%E7%89%8717.png)

运行gplace的命令如图18所示，overflow参数默认为0.1，用户也可以自行定义。在gplace阶段，是不会去修复所有的单元重叠，标准单元的合法化需要到dplace阶段才会实现，在gplace阶段，会不断对标准单元的位置进行优化迭代，直到overflow达到所设定的值，如图19所示，经过420次迭代后满足设定的overflow值0.01。

图18：

![输入图片说明](.image/%E5%9B%BE%E7%89%8718.png)

图19：

![输入图片说明](.image/%E5%9B%BE%E7%89%8719.png)

跑单步gplace命令如下：
```
./run_flow.py -d gcd -s gplace -p pdn 
```

#### （5）resize
resize这一步骤主要是在dplace前，进行一部分标准单元的更换及插入，其中包括将逻辑0和逻辑1的驱动端加上Tie cell和在需要fix fanout的驱动端加上buffer。resize阶段需要配置的参数主要有“MAX_FANOUT”以及fix fanout时需要用到的Tie cell和buffer类型，如图20所示。

图20：

![输入图片说明](.image/%E5%9B%BE%E7%89%8720.png)

在iFlow的resize流程中，主要是进行fanout的修复，降低fanout以增加各级的驱动能力，具体的命令如图21所示。此外，还可以通过命令指定修复cap和slew所用的buffer类型，分别为“repair_max_cap -buffer_cell $buffer_cell”、“repair_max_slew -buffer_cell $buffer_cell”。

图21：

![输入图片说明](.image/%E5%9B%BE%E7%89%8721.png)

跑单步resize命令如下：
```
./run_flow.py -d gcd -s resize -p gplace 
```

#### （6）dplace
iFlow中dplace的主要作用是对gplace阶段已经摆放的标准单元进行合法化，消除标准单元之间的重叠，将标准单元对齐到core area范围内的Row上，从而确保电源网络能为标准单元供电，又称为detail place。dplace流程的主要命令为“detailed_placement”，dplace这一步只是将标准单元位置进行合法化，因此不需要设置参数。
跑单步dplace命令如下：
```
./run_flow.py -d gcd -s dplace -p resize 
```

### 5、CTS
CTS的全称为Clock Tree Synthesis，时钟树综合，这是后端物理设计的一个关键步骤，EDA工具会根据时序约束文件，创建真实的时钟，并构建时钟树，目的是通过插入buffer或inverter的方法使得同一时钟域到各个寄存器时钟端的延迟尽可能保持一致，即时钟skew尽可能小。进行CTS流程前，需要设置用于构建时钟树的buffer的cell类型，如图22所示。

图22：

![输入图片说明](.image/%E5%9B%BE%E7%89%8722.png)

与CTS相关的主要命令如图23所示，构建时钟树之前需要先对原有的buffer和inverter进行resize操作，即通过更换buffer和inverter的尺寸已增强驱动能力，在时钟树综合时再根据所需插入buffer和inverter，时钟树构建之后，这时已有实际的时钟，使用命令“repair_clock_nets”修cap，slew和skew。此外，还需要重新进行一次dplace，因为CTS时会插入buffer和inverter，需要再次dplace来保证标准单元位置摆放的合法化。

图23：

![输入图片说明](.image/%E5%9B%BE%E7%89%8723.png)

跑单步CTS命令如下：
```
./run_flow.py -d gcd -s cts -p dplace
```

### 6、filler
在构建时钟树，并完成timing的修复之后，所有的标准单元已经确认并固定，后续的操作不会改变网表，这时，我们需要在整个core area范围内填满filler cell，主要作用是为了填充标准单元之间的空隙，将整个扩散层连接起来，以满足DRC（Design Rule Check）要求，以构成power rail，使电源和地线保持连接。这一步骤也可以再布线之后进行，在iFlow中，默认是在CTS之后，布线之前进行filler cell的插入，用户可以根据需求进行调整。在进行filler insert操作前，需要设置filler cell的类型，如图24所示，这里一共使用了多种不同大小的filler cell，最小的filler cell宽度与一个Site宽度一致。然后，使用命令“filler_placement $FILL_CELLS”即可填充filler。

图24：

![输入图片说明](.image/%E5%9B%BE%E7%89%8724.png)

跑单步filler命令如下：
```
./run_flow.py -d gcd -s filler -p cts
```

### 7、布线
在iFlow中，布线一共分为两步流程，分别是groute和droute，groute生成一个引导布线文件guide，droute读入guide完成实际的布线。
#### （1）groute
groute又称为global route，这一步骤会做好布线资源分配，生成布线引导文件“route.guide”。groute主要设置的参数为各金属层在库里面的对应名字，用于确定布线所用层，对于不同的工艺有不同数量的金属层，每层金属的名称也不一样，sky130工艺一共有六层金属层，如图25所示，同时，还需定义用于信号线网和时钟线网的走线层。

图25：

![输入图片说明](.image/%E5%9B%BE%E7%89%8725.png)

在开始groute前，如果设计中有用到sram等marco，还需要给marco加上routing blockage，避免在布线时外部的走线与marco内部走线重叠而产生短路，如图26所示。加上routing blockage后，便可以开始groute，命令如图27所示，这里设置200次迭代，groute阶段必须保证完全消除overflow，从而避免存在短路现象，否则会使芯片功能错误。

图26：

![输入图片说明](.image/%E5%9B%BE%E7%89%8726.png)

图27：

![输入图片说明](.image/%E5%9B%BE%E7%89%8727.png)

跑单步groute命令如下：
```
./run_flow.py -d gcd -s groute -p filler
```

#### （2）droute
droute流程是将groute输出的route.guide文件读入，并根据guide文件的描述去形成实际布线的过程，又称为detail place。这一步骤的实施主要是依赖groute输出的route.guide文件，因此，没有参数需要设置，读入相应的lef物理库和guide文件之后，便可以开始droute。droute步骤的命令在顶层脚本“run_flow.py”中实现，如图28所示。

图28：

![输入图片说明](.image/%E5%9B%BE%E7%89%8728.png)

跑单步droute命令如下：
```
./run_flow.py -d gcd -s droute -p groute
```

### 8、版图
droute完成后输出的是def文件，而不是gds文件，需要得到用于foundry生产的gds文件还需要一个merge的流程，在iFlow中，这一流程命名为“layout”。droute得到的def文件是一个基于金属层层面的描述文件，其中的标准单元、IO cell以及marco等等都是一个黑盒子，只描述了其形状，没有具体的layer层描述，merge流程是将这些黑盒子的gds和def文件进行合并，从而得到最终的gds文件的过程。
merge过程的具体命令在顶层脚本“run_flow.py”中实现，如图29所示，merge需要读入的文件包括droute输出的def，还有标准单元、IO cell、marco的gds文件，以及工艺的layer map文件klayout.lyt和klayout.lyp，最终输出gds版图。

图29：

![输入图片说明](.image/%E5%9B%BE%E7%89%8729.png)

跑单步layout（merge）命令如下：
```
./run_flow.py -d gcd -s layout -p droute 
```
得到gds版图后，可以使用klayout工具查看版图。此外，klayout工具还可以查看def文件，打开klayout的GUI界面后，在菜单“File/Import”的子菜单中选择DEF/LEF导入def文件以及lef文件。如图30所示，在弹窗的“Import File”中选择detail route生成的def文件导入，在“With LEF files:”中添加design中标准单元、IO cell及marco的lef文件，在“iFlow/foundry/sky130/lef”中可以找到，添加完毕后点“OK”即可导入。产生的结果如图31所示，这可以在merge前帮助我们检验布线结果的质量，也可以检查前面每一步之后的结果，包括floorplan、filler等等。

图30：

![输入图片说明](.image/%E5%9B%BE%E7%89%8730.png)

图31：

![输入图片说明](.image/%E5%9B%BE%E7%89%8731.png)

klayout也可以直接打开GDS，使用klayout打开GDS的命令如下：
```
klayout  xxxx.gds
```

图32：

![输入图片说明](.image/%E5%9B%BE%E7%89%8732.png)

# 开源EDA流程iFlow使用示例——更换设计
## 一、gcd设计
gcd(greatest common denominator)是一个计算最小公分母的设计，是一个非常小的设计，一个百门级别的芯片。使用sky130工艺库，去实现gcd设计的后端物理设计的流程及运行的命令可以参考上一部分的iFlow介绍。从综合流程的log显示，如图33所示，gcd设计综合后一共有639个cell，是一个非常小的设计。

图33：

![输入图片说明](.image/%E5%9B%BE%E7%89%8733.png)

## 二、uart设计
uart设计是一种通用串行数据总线的设计，是一个百门级到千门级的设计，用于异步通信。下面将讲述一下如何将iFlow中的design更换为uart设计。

首先，需要把uart相关的rtl代码放在“iFlow/rtl”目录下，如图34所示，然后要定义uart设计的flow，进入到“iFlow/scripts/cfg”目录下，编辑脚本“flow_cfg.py”，加入uart设计的默认flow参数，如图35所示，这里设置的默认foundry为“asap7”，改为“sky130”也是可以的。

图34：

![输入图片说明](.image/%E5%9B%BE%E7%89%8734.png)

图35：

![输入图片说明](.image/%E5%9B%BE%E7%89%8735.png)

定义好flow之后，我们需要准备uart设计的流程脚本，进入到“iFlow/scripts”目录，运行命令：
```
cp -r gcd uart
```
拷贝gcd设计的脚本作为uart设计的脚本，再进行相应的参数修改即可。首先，进入“iFlow/scripts/uart”目录，修改综合脚本“synth.yosys_0.9.tcl”，需要把输入的Verilog代码文件改为uart设计的rtl代码，如图36所示。

图36：

![输入图片说明](.image/%E5%9B%BE%E7%89%8736.png)

由于uart设计的规模和gcd设计非常接近，在使用sky130工艺的情况下，我们可以沿用gcd设计的floorplan设置，也可以适当的调节DIE_AREA和CORE_AREA，如图37所示，

图37：

![输入图片说明](.image/%E5%9B%BE%E7%89%8737.png)

其余的步骤可以不用修改，进入目录“iFlow/scripts”，运行命令：
```
./run_flow.py -d uart -s synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,groute,droute,layout -f sky130 -t HS -c TYP -v V1 -l V1
```
即可基于sky130工艺跑uart设计的后端流程，结果如图38所示。

图38：

![输入图片说明](.image/%E5%9B%BE%E7%89%8738.png)

## 三、aes_cipher_top设计
aes_cipher_top是一个加密算法的小模块，相对于前面两个设计，aes_cipher_top的规模要大很多，是一个万门级的设计。与uart设计一样，首先要修改综合脚本中的Verilog代码路径，然后调整floorplan，增大芯片的面积，如图39所示。

图39：

![输入图片说明](.image/%E5%9B%BE%E7%89%8739.png)

然后进入目录“iFlow/scripts”，运行命令
```
./run_flow.py -d aes_cipher_top -s synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,groute,droute,layout -f sky130 -t HS -c TYP -v V1 -l V1
```
即可完成基于sky130工艺跑aes_cipher_top设计的后端流程，结果如图40所示，这个设计比较大，后端流程中droute步骤需要比较长的时间，大约需要一个小时。

图40：

![输入图片说明](.image/%E5%9B%BE%E7%89%8740.png)

# 练习：picorv32设计更换并跑通后端流程
picorv32是一个实现RISC-V RV32IMC指令集的CPU内核，大家可以尝试更换picorv32设计跑后端流程。

picorv32代码源地址：https://github.com/YosysHQ/picorv32

# 开源EDA流程iFlow使用示例——更换工艺库
## 一、nangate45
Nangate45 PDK的源地址为：https://eda.ncsu.edu/freepdk/。在iFlow中的nangate45工艺库是经过整理的。

要想用nangate45工艺库来设计后端，首先要将nangate45工艺库加到iFlow中，将nangate45工艺库整理后放在“iFlow/foundry”目录下。然后进入“iFlow/scripts/cfg”目录，编辑脚本“foundry_cfg.py”，配置好lib、lef和gds库的路径以及综合阶段需要禁掉的单元列表“don’t use list”。

图41：

![输入图片说明](.image/%E5%9B%BE%E7%89%8741.png)

然后需要在脚本中加入nangate45工艺库的参数设置，这里用aes_cipher_top设计的综合脚本举例，如图42所示，对于不同的工艺库，所用到的TIE cell和buffer名称是不一样的，需要根据工艺库进行修改，对于其他步骤的脚本也是如此。

图42：

![输入图片说明](.image/%E5%9B%BE%E7%89%8742.png)

其中电源网络的脚本，需要引用nangate45工艺的电源网络配置“pdn_nangate45.cfg”，因为每个工艺电源网络的配置差别是比较大的。脚本参数修改完之后，运行命令：
```
./run_flow.py -d aes_cipher_top -s synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,groute,droute,layout -f nangate45 -t HD -c TYP -v V1 -l V1
```
基于nangate45工艺跑aes_cipher_top设计的后端结果如图43所示。

图43：

![输入图片说明](.image/%E5%9B%BE%E7%89%8743.png)

## 二、asap7
asap7的源地址为：https://asap.asu.edu/。在iFlow中的asap7工艺库是经过整理的。

asap7是开源的7nm工艺，因此我们需要把floorplan面积调得更小，以保证在一定的利用率下能够顺利布线，和nangate45工艺类似，修改相应的脚本参数之后，如图44和45所示，

图44：

![输入图片说明](.image/%E5%9B%BE%E7%89%8744.png)

图45：

![输入图片说明](.image/%E5%9B%BE%E7%89%8745.png)

运行命令：
```
./run_flow.py -d gcd -s synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,groute,droute,layout -f asap7 -t HS -c TYP -v V1 -l V1
```
即可完成基于asap7工艺跑gcd设计的后端流程，droute步骤大约需要两小时，结果如图46所示。

图46：

![输入图片说明](.image/%E5%9B%BE%E7%89%8746.png)

大家也可以尝试一下用asap7工艺去跑uart设计，但不建议用来尝试aes_cipher_top设计，因为aes_cipher_top设计比较大，droute步骤会存在很多DRC违例，工具在解DRC时需要花费大量时间，可能还绕不通线。

# 开源EDA流程iFlow使用示例——更换工具（iEDA）
## 一、工具导入及存放
iEDA工具已经嵌套在iFlow中，更换工具时，首先需要把工具放在“iFlow/tools/”目录下，如图47所示，iEDA_0.1版本已经放在“iFlow/tools/”目录下，

图47：



## 二、配置工具相关参数
将iEDA工具的路径配置到脚本“iFlow/scripts/cfg/ tools_cfg.py”中，配置iEDA工具可以完成的后端流程步骤，配置iEDA工具的版本号，如图48所示。

图48：



## 三、Flow步骤定义
定义使用iEDA工具时的flow步骤，如图49所示，在使用iEDA工具时，flow的步骤由默认的“synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,
groute,droute,layout”变为“synth,v2def,floorplan,fix_fanout,place,cts,fix_drv,opt_hold,route,filler”，这是对应iEDA工具的步骤。iEDA目前只支持后端物理流程，因此，综合依旧使用yosys工具完成。并且，由于iEDA工具目前只支持def文件的输入，这里需要借助OpenRoad工具将综合网表“.v”文件转化为def文件作为iEDA工具的输入。

图49：



## 四、定义工具对应的Flow
定义Flow时，需要加上flow的标识flag，当要使用默认的flow步骤时，标识flag设为空即可，当要使用iEDA的flow步骤是，将标识flag设为“iEDA”，如图50所示。配置完成之后，再将工具对应的脚本加入到对应的设计脚本目录下即可使用。

图50：



