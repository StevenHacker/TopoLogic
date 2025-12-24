# 使用官方 PyTorch 镜像，匹配 README 中的 CUDA 11.1 和 PyTorch 1.9.1 要求
# 注意：该镜像基于 Ubuntu 20.04 或 18.04
FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-devel

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
# 确保使用 CUDA 进行编译（如果需要从源码编译 mmcv 等）
ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="7.0 7.5 8.0 8.6+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"

# 安装必要的系统依赖
# ninja-build: 加速 PyTorch 扩展编译
# libgl1-mesa-glx, libglib2.0-0: OpenCV 依赖
RUN apt-get update && apt-get install -y \
    git \
    wget \
    vim \
    ninja-build \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender-dev \
    libxext6 \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /workspace

# 复制 requirements.txt
COPY requirements.txt /workspace/requirements.txt

# 升级 pip 并安装依赖
# 注意：requirements.txt 中包含 mmcv-full 的 -f 链接
# 如果下载速度慢，可以考虑更换 pip 源，例如: -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 复制项目代码
COPY . /workspace

# 将当前目录添加到 PYTHONPATH，确保可以导入模块
ENV PYTHONPATH="/workspace:${PYTHONPATH}"

# 验证安装 (可选)
RUN python -c "import torch; print(f'PyTorch: {torch.__version__}, CUDA: {torch.version.cuda}')" && \
    python -c "import mmcv; print(f'MMCV: {mmcv.__version__}')" && \
    python -c "import mmdet; print(f'MMDet: {mmdet.__version__}')" && \
    python -c "import mmdet3d; print(f'MMDet3D: {mmdet3d.__version__}')"

# 默认启动命令
CMD ["/bin/bash"]
