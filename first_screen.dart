import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:sqflite_demo2/Model.dart';
import 'package:sqflite_demo2/first _screen_controller.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  TextEditingController nameController =  TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();

  RxString imageshow="".obs;

  var firstController = Get.put(FirstScreenController());

  List items =List.generate(10, (index) => index);

  @override
  void initState() {
    dateController!.text= "";
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQFLITE IMAGE AND DATE PICKER"),),

      body:Obx(() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.separated(
          itemCount: firstController.model.length,
          itemBuilder: (context,index){
            return Container(
              // height: 70,
              // width: 98,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.7),
                    offset: Offset(0.5,0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Dismissible(
                background: Container(
                  color: Colors.red,
                 child: Icon(Icons.delete),
                ),
                key: ValueKey(items[index]),
               onDismissed: (DismissDirection direction){
                  firstController.deleteTodo(id: firstController.model[index].id!);
               },

              child: ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        maxRadius: 35,
                        backgroundImage: FileImage(File("${firstController.model[index].image}")),
                      ),
                    ),
                    SizedBox(width: 10,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${firstController.model[index].id}"),
                        Text("${firstController.model[index].name}"),
                        Text("${firstController.model[index].desc}"),
                        Text("${firstController.model[index].date}"),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await buildShowModalBottomSheet(context,isUpdate:true,id:firstController.model[index].id);
                        nameController.text = firstController.model[index].name!;
                        descriptionController.text = firstController.model[index].desc!;
                        dateController.text=firstController.model[index].date!;
                      },
                        child: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              ),


            );
          }, separatorBuilder: (context,index){return SizedBox(height: 10,);},),
      ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await buildShowModalBottomSheet(context, isUpdate: false);
          },
        child: Icon(Icons.add),
        tooltip: "FLOATINGACTION BUTTON",
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context, {required bool isUpdate, String? id}) async {
    showModalBottomSheet(context: context,
        builder: (BuildContext context){
            return SingleChildScrollView(
              child: Container(
                height: 600,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          maxRadius: 50,
                          child: ClipOval(
                            child: imageshow.value != ""
                                ? Image.file(File(imageshow.value),fit: BoxFit.fill,width: 100,)
                                :
                                GestureDetector(
                                  // onTap: ()async{
                                  //   final XFile? image =
                                  //       await picker.pickImage(source: ImageSource.gallery);
                                  //   setState(() {
                                  //     show = File(image!.path);
                                  //     print("done");
                                  //   });
                                  // },
                                  //   child: Icon(Icons.camera_alt)
                                onTap: (){
                                  showModalBottomSheet(context: context, builder: (context){
                                    return Container(
                                      height: 130,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15,left: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("profile Photos ",style: TextStyle(color: Colors.blue),),
                                                SizedBox(width: 230,),
                                              Icon(Icons.delete,color: Colors.blue,),
                                              ],
                                            ),

                                            SizedBox(height: 5,),

                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    TextButton(onPressed: ()async{
                                                      final XFile? image =
                                                          await picker.pickImage(source: ImageSource.camera);
                                                      imageshow.value = image!.path;
                                                      Navigator.pop(context);
                                                    }, child: Icon(Icons.camera_alt),),
                                                    Text("Camera",style: TextStyle(color: Colors.blue)),
                                                  ],
                                                ),

                                                SizedBox(width: 5),


                                                Column(
                                                  children: [
                                                    TextButton(onPressed: ()async{
                                                      final XFile? image =
                                                      await picker.pickImage(source: ImageSource.gallery);
                                                      imageshow.value =image!.path;
                                                      Navigator.pop(context);
                                                    }, child: Icon(Icons.image,size: 30,),),
                                                    Text("Image",style: TextStyle(color: Colors.blue),),
                                                  ],
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  );
                                },
                                  child: Icon(Icons.camera_alt,color: Colors.white,),
                                ),

                          )
                        ),

                        SizedBox(height: 10,),

                        TextFormField(
                          validator: (v){
                            if(v!.isEmpty){
                              return "enter name";
                            }
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           ),
                            hintText: "name",
                            labelText: "name",
                          ),
                        ),

                        SizedBox(height: 10,),

                        TextFormField(
                          validator: (v){
                            if(v!.isEmpty){
                              return "enter description";
                            }
                          },
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText:"description",
                            labelText: "description",
                          ),
                        ),

                        SizedBox(height: 20,),

                      TextFormField(
                        onTap: () async {
                          DateTime? pickedDate =
                              await  showDatePicker(context: context,
                              initialDate: DateTime.now(),
                              firstDate:DateTime(2000),
                              lastDate:DateTime(2040));
                          if(pickedDate !=null){
                            String formatedData =
                            DateFormat("dd-MM-yyyy").format(pickedDate);
                            setState(() {
                              dateController!.text=formatedData.toString();
                            });
                          }
                        },
                        controller: dateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "dd-mm-yyyy",
                          labelText: "date",
                        ),
                      ),

                        // TextButton(onPressed: (){
                        //   showDatePicker(
                        //       context: context,
                        //       initialDate: DateTime.now(),
                        //       firstDate: DateTime(2000),
                        //       lastDate: DateTime(2030),
                        //   ).then((value){
                        //         print(value);
                        //       });
                        // }, child: Text("OPEN DATE PICKER"),),

                        SizedBox(height: 10,),

                        GestureDetector(
                          onTap: (){
                            if(_formkey.currentState!.validate()){
                              if(isUpdate == false){
                                firstController.adddata( image: imageshow.value,  name: nameController.text, desc: descriptionController.text, date: dateController.text);
                              }
                              else{
                                firstController.updateTodo(Modelclass(id: id!,  image: imageshow.value,  name: nameController.text,desc: descriptionController.text,date: dateController.text));

                              }
                              // firstController.adddata(name: nameController.text, desc: descriptionController.text, date: dateController.text);
                              Navigator.pop(context);
                              nameController.clear();
                              descriptionController.clear();
                              dateController.clear();
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(child: Text("save"),),
                          ),
                        ),

                        SizedBox(height: 7,),

                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){
                                nameController.clear();
                                descriptionController.clear();
                                dateController.clear();
                                // Navigator.pop(context);
                              },
                              child: Text("cancle"),
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
  }
}
