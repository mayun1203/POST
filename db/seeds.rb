# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#管理者
Admin.create!(
  email: 'admin@admin',
  password: '111111'
)

#会員
User.create!(
  name: '山田花子',
  account_id: '@hanako',
  email: 'test@test',
  phone_number: '09000000000',
  password: '111111'
  )

User.create!(
  name: '鈴木太郎',
  account_id: '@taro',
  email: 'test1@test1',
  phone_number: '09000000000',
  password: '111111'
  )

User.create!(
  name: '東京まみ',
  account_id: '@mami',
  email: 'test2@test2',
  phone_number: '09000000000',
  password: '111111'
  )

User.create!(
  name: 'ベッキー',
  account_id: '@becky',
  email: 'test3@test3',
  phone_number: '09000000000',
  password: '111111'
  )