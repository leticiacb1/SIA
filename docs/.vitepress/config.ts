import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({

  base: '/SIA/',   // Para deploy no Github Pages

  title: "SIA - Scalable infrastructure for applications",
  description: "Tutorial de criação de uma infraestrutura escalonável para aplicações na AWS",

  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
    ],

    sidebar: [
      {
        text: 'Tópicos',
        items: [
          {
            text: 'Home',
            link: '/'
          }, {
            text: 'Entendendo o Projeto',
            link: '/contextualizacao'
          }, {
            text: 'SIA',
            link: '/primeiros-passos'
          }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/leticiacb1/SIA' }
    ],

    outline: 'deep',
    outlineTitle: 'Tópicos',

  }
})
