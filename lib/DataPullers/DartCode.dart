// JobData jobData = new JobData();
// jobData.Title = job.data()["Title"];
// jobData.Department = job.data()["Department"];
// jobData.url = job.data()["URL"];
// jobData.Total_Vacancies = job.data()["Total_Vacancies"];
// jobData.WebsiteLink = job.data()["WebsiteLink"];
// jobData.Location = job.data()["Location"];
// jobData.ApplicationFees = job.data()["ApplicationFees"];
// jobData.Important_Dates = job.data()["Important_Dates"];
// jobData.HowToApply = job.data()["HowToApply"];
// jobData.Key = job.id;
// jobData.ApplyLink = job.data()["ApplyLink"];
// jobData.WebsiteLink = job.data()["WebsiteLink"];
// jobData.NotificationLink = job.data()["NotificationLink"];
//
// jobData.Short_Details = job.data()["Short_Details"].toString().replaceAll("Short Details of Notification", "");
//
// print("<" + jobData.Short_Details + ">");
//
// if(jobData.Short_Details.replaceAll("Short Details of Notification", "") == "" || jobData.Short_Details.replaceAll("Short Details of Notification", "") == "\n")
// {
// jobData.Short_Details = job.data()["Total_Vacancies"].toString().replaceAll("Vacancy Details Total : ", "");
// }
//
// FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails").get().then((vdetails){
// vdetails.docs.forEach((vdtl) {
// VacancyDetails vacancyDetails = new VacancyDetails();
// vacancyDetails.Title = vdtl.data()["Title"];
// vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
// vacancyDetails.headers = vdtl.data()["headers"];
//
// FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
// vdetaildata.docs.forEach((vdtldata) {
// VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
// vacancyDetailsData.data = vdtldata.data()["data"];
//
// vacancyDetails.datas.add(vacancyDetailsData);
// });
// });
//
// jobData.VDetails.add(vacancyDetails);
//
// });
// });
