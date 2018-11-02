//
//  ViewController.swift
//  iOS-Schedule
//
//  Created by 柯平常 on 2018/11/2.
//  Copyright © 2018 柯平常. All rights reserved.
//

import UIKit
import EventKit
import HealthKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        writecalendar()
//        writereminder()
    }
    
    
    
    // 写入数据到健康应用
    
    private func writehealth(){
        
        
        /*
         * 检查 HealthKit 是否在设备上有效。如果无效，返回失败和错误。
         * 准备 Prancercise Tracker 将要读取和写到 HealthKit 中的健康数据的类型。
         * 将这些数据放到一个读取/写入类型的数组中。
         * 请求授权。如果成功，返回成功并结束。
         */
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("设备问题无法使用")
            return
        }
        
        
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                print("数据问题无法使用")
                return
        }
        
        
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       bloodType,
                                                       biologicalSex,
                                                       bodyMassIndex,
                                                       height,
                                                       bodyMass,
                                                       HKObjectType.workoutType()]
        
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            print(success)
        }
        
        
        
    }
    
    
    
    
    
    // 写入事件到日历
    private func writecalendar(){
        
        //        （1）、创建事件驱动器：
        let eventStore = EKEventStore()
        
        //        （2）、授权访问日历：
        eventStore.requestAccess(to: .event) { (result, erro) in }
        
        //        （3）、编辑事件：
        let event = EKEvent(eventStore: eventStore)
        // 事件名称
        event.title = "提醒" // 事件名称
        event.notes = "开始运动了" // 事件备注
        
        // 事件地点
        event.location = "深圳软件园"
        
        // 这个设置为true 开始结束时间就不会显示
        event.isAllDay = true
        
        // 开始时间
        event.startDate = Date()
        // 结束时间
        event.endDate = Date(timeIntervalSinceNow: 3600)
        
        event.addAlarm(EKAlarm(relativeOffset: -60*15)) // 设置提醒
        
        // 必须设置：系统的日历
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        //        （4）、添加事件：
        do {
            let _ = try eventStore.save(event, span: .thisEvent)
            
        } catch {
            print(error)
        }
    }
    
    
    // 写入事件到提醒事项
    private func writereminder(){
        
//        （1）、创建事件驱动器：
        let eventStore = EKEventStore()
        
//        （2）、授权访问提醒事项：
        eventStore.requestAccess(to: .reminder) { (result, erro) in }
        
//        （3）、编辑事项：
        let reminde = EKReminder(eventStore: eventStore)
        
        // 事项名称
        reminde.title = "测试提醒"
        // 事项地点
        reminde.location = "深圳软件科技园"
        
        // 事项等级：1-9，1最高
        reminde.priority = 1
        
        reminde.notes = "测试测试测试测试测试"
        
        // 事项开始事件
        var start = DateComponents()
        start.day = 5
        start.year = 2016
        start.month = 9
        start.hour = 22
        start.minute = 30
        start.timeZone = NSTimeZone.system
        reminde.startDateComponents = start
        
        // 事项结束事件
        var end = DateComponents()
        end.day = 8
        end.year = 2016
        end.month = 9
        end.hour = 23
        end.minute = 30
        end.timeZone = NSTimeZone.local
        reminde.dueDateComponents = end
        // 说明：
//        设置了结束时间，在事项中只会显示结束时间而不会显示开始时间
        
        
        reminde.addAlarm(EKAlarm(relativeOffset: -60*15)) // 添加提醒时间
        
        // 必须要设置:默认的事项提示app
        reminde.calendar = eventStore.defaultCalendarForNewReminders()
        
//        （4）、添加事项：
        do {
            let _ = try eventStore.save(reminde, commit: true)
            
        } catch {
            print(error)
        }
    }
    
}

