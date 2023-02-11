//
//  DirectoryView.swift
//  BlockEmployeeDirectory
//
//  Created by Danny on 2/2/23.
//

import SwiftUI

struct DirectoryView: View {
    
    @StateObject private var viewModel = DirectoryViewModel()
    
    var body: some View {
        List {
            if let list = viewModel.employeeList, list.employees.count > 0 {
                ForEach(list.employees) { e in
                    EmployeeView(viewModel: viewModel, employee: e)
                }
            } else {
                Text("Hmmm... Looks like nothing is here. Try pulling to refresh!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
            }
        }
        .navigationTitle("Employee Directory")
        .listStyle(.insetGrouped)
        .refreshable {
            viewModel.refresh()
        }
        .onAppear(perform: viewModel.refresh)
    }
}


struct EmployeeView: View {
    
    private var viewModel: DirectoryViewModel
    private var employee: Employee
    @State private var imageView: Image = Image("blank-profile")
    
    init(viewModel: DirectoryViewModel, employee: Employee) {
        self.viewModel = viewModel
        self.employee = employee
    }
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    imageView
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .cornerRadius(5)
                }.task {
                    if let photoUrl = employee.photoUrlSmall {
                        imageView = await viewModel.getImage(urlString: photoUrl)
                    }
                }
                    
                VStack {
                    Text(employee.fullName)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading], 8)
                        .padding([.bottom], 1)
                    Text(employee.team)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading], 8)
                        .padding([.bottom], 1)
                    Text(employee.employeeType.description())
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading], 8)
                        .padding([.bottom], 1)
                    Text(employee.emailAddress)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading], 8)
                        .padding([.bottom], 1)
                    if let phoneNumber = employee.phoneNumber {
                        Text(viewModel.formattedPhoneNumber(phoneNumber))
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 8)
                            .padding([.bottom], 1)
                    }
                }
                .frame(minHeight: 100)
            }
            if let bio = employee.biography {
                Text(bio)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
    }
}


struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
