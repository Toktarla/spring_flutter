package com.example.toktarcodes.controller;

import com.example.toktarcodes.model.Student;
import com.example.toktarcodes.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/student")
public class StudentController {
    @Autowired
    private StudentRepository studentRepository;


    @GetMapping("/getAll")
    public List<Student> getAllStudents(){
        return studentRepository.findAll();
    }

    @PostMapping("/add")
    public String add(@RequestBody Student student){
        studentRepository.save(student);
        return "Added succesfully";
    }

    @PutMapping("/update/{id}/{name}/{address}")
    public String updateTask(@PathVariable Integer id,@PathVariable String name,@PathVariable String address){
        boolean exist = studentRepository.existsById(id);
        if(exist){
            Student task = studentRepository.getById(id);
            task.setName(name);
            task.setAddress(address);
            studentRepository.save(task);
            return "Task is updated";
        }
        return "Task is not exist";
    }
    @DeleteMapping("/delete/{id}")
    public String deleteTask(@PathVariable Integer id){
        boolean exist = studentRepository.existsById(id);
        if(exist){
            studentRepository.deleteById(id);
            return "Task is deleted";
        }
        return "Task is not exist";
    }



}
