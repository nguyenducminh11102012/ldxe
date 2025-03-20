# Sử dụng Node.js 20 làm base image
FROM node:20

# Cập nhật hệ thống và cài đặt Git
RUN apt-get update && apt-get install -y git

# Tạo thư mục làm việc
WORKDIR /etc

# Clone mã nguồn của Skyport Panel (sử dụng phiên bản ổn định v0.2.2)
RUN git clone --branch v0.2.2 https://github.com/skyportlabs/panel skyport

# Chuyển vào thư mục dự án
WORKDIR /etc/skyport

# Cài đặt các dependencies
RUN npm install

# Seed dữ liệu và tạo user admin
RUN npm run seed && npm run createUser

# Mở cổng 3001
EXPOSE 3001

# Chạy ứng dụng
CMD ["node", "."]
