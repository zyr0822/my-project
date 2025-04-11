<!-- <template>
  <AppPage>
    <h1>图书管理</h1>
  </AppPage>
</template> -->

<template>
  <CommonPage show-footer title="图书管理">
    <template #action>
      <NButton type="primary" @click="handleAdd">
        <TheIcon icon="material-symbols:add" :size="18" class="mr-5" />新增图书
      </NButton>
    </template>
    
    <CrudTable
      ref="$table"
      v-model:query-items="queryItems"
      :columns="columns"
      :get-data="getBookList"
    >
      <template #queryBar>
        <QueryBarItem label="书名" :label-width="50">
          <NInput
            v-model:value="queryItems.title"
            clearable
            placeholder="请输入书名"
            @keypress.enter="$table?.handleSearch()"
          />
        </QueryBarItem>
        <QueryBarItem label="作者" :label-width="50">
          <NInput
            v-model:value="queryItems.author"
            clearable
            placeholder="请输入作者"
            @keypress.enter="$table?.handleSearch()"
          />
        </QueryBarItem>
        <QueryBarItem label="分类" :label-width="50">
          <NSelect
            v-model:value="queryItems.category"
            clearable
            :options="categoryOptions"
            placeholder="请选择分类"
          />
        </QueryBarItem>
      </template>
    </CrudTable>
  </CommonPage>
</template>

<script setup>
import { h, ref } from 'vue'
import { NButton, NTag, NInput, NSelect, NImage } from 'naive-ui'
import CommonPage from '@/components/page/CommonPage.vue'
import QueryBarItem from '@/components/query-bar/QueryBarItem.vue'
import CrudTable from '@/components/table/CrudTable.vue'
import TheIcon from '@/components/icon/TheIcon.vue'
import { renderIcon } from '@/utils'

const $table = ref(null)
const queryItems = ref({
  title: '',
  author: '',
  category: ''
})

const categoryOptions = [
  { label: '文学', value: 'literature' },
  { label: '科技', value: 'technology' },
  { label: '历史', value: 'history' },
  { label: '经济', value: 'economics' }
]

const columns = [
  {
    title: '封面',
    key: 'cover',
    width: 80,
    align: 'center',
    render(row) {
      return h(NImage, {
        width: 50,
        src: row.cover || 'https://via.placeholder.com/50',
        fallbackSrc: 'https://via.placeholder.com/50'
      })
    }
  },
  {
    title: '书名',
    key: 'title',
    width: 120,
    ellipsis: { tooltip: true }
  },
  {
    title: '作者',
    key: 'author',
    width: 100
  },
  {
    title: '分类',
    key: 'category',
    width: 80,
    render(row) {
      const map = {
        literature: '文学',
        technology: '科技',
        history: '历史',
        economics: '经济'
      }
      return h(NTag, { type: 'info' }, { default: () => map[row.category] || row.category })
    }
  },
  {
    title: 'ISBN',
    key: 'isbn',
    width: 120
  },
  {
    title: '库存',
    key: 'stock',
    width: 60,
    align: 'center'
  },
  {
    title: '状态',
    key: 'status',
    width: 80,
    render(row) {
      return h(NTag, { 
        type: row.status === 'available' ? 'success' : 'error'
      }, { 
        default: () => row.status === 'available' ? '可借阅' : '已借出' 
      })
    }
  },
  {
    title: '操作',
    key: 'actions',
    width: 120,
    fixed: 'right',
    render(row) {
      return [
        h(
          NButton,
          {
            size: 'small',
            type: 'primary',
            onClick: () => handleEdit(row)
          },
          { default: () => '编辑', icon: renderIcon('material-symbols:edit', { size: 16 }) }
        ),
        h(
          NButton,
          {
            size: 'small',
            type: 'error',
            style: 'margin-left: 8px;',
            onClick: () => handleDelete(row)
          },
          { default: () => '删除', icon: renderIcon('material-symbols:delete', { size: 16 }) }
        )
      ]
    }
  }
]

// 获取图书列表函数
async function getBookList(params) {
  try {
    // 这里应该是调用API接口，我们先模拟数据
    const mockData = [
      {
        id: 1,
        title: '三体',
        author: '刘慈欣',
        category: 'literature',
        isbn: '9787536692930',
        stock: 5,
        status: 'available',
        cover: 'https://img9.doubanio.com/view/subject/s/public/s2768378.jpg'
      },
      // 更多模拟数据...
    ]
    
    // 筛选逻辑
    const filtered = mockData.filter(book => {
      const matchesTitle = queryItems.value.title 
        ? book.title.includes(queryItems.value.title)
        : true
      const matchesAuthor = queryItems.value.author 
        ? book.author.includes(queryItems.value.author)
        : true
      const matchesCategory = queryItems.value.category 
        ? book.category === queryItems.value.category
        : true
        
      return matchesTitle && matchesAuthor && matchesCategory
    })
    
    return {
      data: filtered,
      page: 1,
      pageSize: 10,
      total: filtered.length
    }
  } catch (error) {
    console.error('获取图书列表失败:', error)
    return { data: [], total: 0 }
  }
}

function handleAdd() {
  // 新增逻辑
}

function handleEdit(row) {
  // 编辑逻辑
}

function handleDelete(row) {
  // 删除逻辑
}
</script>