#!/bin/bash
#./ctags/bin/ctags −−c−kinds=+cf-deglmnpstuvx linux_kernel/linux-3.3-rc3//virt/kvm/kvm_main.c
ctags/bin/ctags --c-kinds=-deglmnpstuvx -R linux_kernel/linux-3.3-rc3//virt/kvm/*

