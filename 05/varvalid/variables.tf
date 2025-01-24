variable "ip_address" {
  type        = string
  description = "IP-адрес"
  validation {
    condition     = can(regex("^(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))$", var.ip_address))
    error_message = "Значение переменной 'ip_address' должно быть корректным IPv4-адресом."
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "Список IP-адресов"
  validation {
    condition     = alltrue([for ip in var.ip_addresses : can(regex("^(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))$", ip))])
    error_message = "Все адреса в списке 'ip_addresses' должны быть корректными IPv4-адресами."
  }
}

variable "example_string" {
  type        = string
  default     = "строка без верзнего регистра"

  validation {
    condition     = can(regex("^[a-zа-яё0-9\\s]*$", var.example_string))
    error_message = "Строка не должна содержать символов верхнего регистра."
  }
}

variable "in_the_end_there_can_be_only_one" {
    description = "Who is better Connor or Duncan?"
    type = object({
        Dunkan  = optional(bool)
        Connor  = optional(bool)
    })

    default = {
        Dunkan  = true
        Connor  = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition     = (var.in_the_end_there_can_be_only_one.Dunkan == true && var.in_the_end_there_can_be_only_one.Connor == false) || (var.in_the_end_there_can_be_only_one.Dunkan == false && var.in_the_end_there_can_be_only_one.Connor == true)
                        
    }
}