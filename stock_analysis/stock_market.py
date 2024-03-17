import streamlit as st
import yfinance as yf
import plotly.express as px

ticker_name = st.text_input('Enter stock symbol', 'INFY')
time_frame = st.selectbox('Select time frame', options=['1mo', '3mo', '6mo', '1y', '2y', '3y', '5y', '10y'])


def fetch_data(tick, timeframe):
    tick = f'{str.upper(tick)}.NS'
    ticker_yf = yf.Ticker(tick)
    data = yf.download(tick, period=timeframe)
    return ticker_yf, data


ticker, hist = fetch_data(ticker_name, time_frame)

st.title('Welcome to Stock market Analysis')
options = st.sidebar.radio('Analysis', options=['stock statistic',
                                                'stock data',
                                                'plot data',
                                                'Income Statement',
                                                'Balance Sheet',
                                                'Cash Flow',
                                                'Holdings',
                                                'Major Transaction',
                                                'Recommendations'])




def stats(df):
    st.header('Stock Statistics fot the time period')
    st.write(df.describe())


def show_data_from_last_five_day(df):
    st.header('there are last five days data')
    st.write(df.tail(5))


def plot_data(df):
    st.header('plotting data')
    y_axis_col = st.selectbox('Select column to plot data', options=df.columns)
    fig = px.line(df, x=df.index, y=y_axis_col)
    st.plotly_chart(fig)

    hist['14_days_close'] = hist['Close'].rolling(window=14).mean()
    hist['30_days_close'] = hist['Close'].rolling(window=30).mean()
    hist['90_days_close'] = hist['Close'].rolling(window=90).mean()
    hist['180_days_close'] = hist['Close'].rolling(window=180).mean()
    fig2 = px.line(hist, x=df.index, y='Close')
    fig2.add_scatter(x=df.index, y=df['14_days_close'], name='14 days')
    fig2.add_scatter(x=df.index, y=df['30_days_close'], name='30 days')
    fig2.add_scatter(x=df.index, y=df['90_days_close'], name='90 days')
    fig2.add_scatter(x=df.index, y=df['180_days_close'], name='180 days')
    st.plotly_chart(fig2)





def income_statement(stock):
    st.header('Yearly Income Statement')
    st.dataframe(stock.income_stmt)
    st.header('Quarterly Income Statement')
    st.dataframe(stock.quarterly_income_stmt)


def balance_sheet(stock):
    st.header('Yearly balance sheet')
    st.dataframe(stock.balance_sheet)
    st.header('Quarterly balance sheet')
    st.dataframe(stock.quarterly_balance_sheet)


def cash_flow(stock):
    st.header('Yearly Cash Flow')
    st.dataframe(stock.cash_flow)
    st.header('Quarterly Cash Flow')
    st.dataframe(stock.quarterly_cash_flow)


def holding(stock):
    st.header('Major Stock Holders')
    st.write(stock.major_holders)
    st.header('Institutional Holders')
    st.write(stock.institutional_holders)
    st.header('Mutual fund house Holders')
    st.write(stock.mutualfund_holders)


def major_transaction(stock):
    st.header('Insider transactions')
    st.write(stock.insider_transactions)
    st.header('Insider Purchases')
    st.write(stock.insider_purchases)
    st.header('Insider Roster Holders')
    st.write(stock.insider_roster_holders)


def recommendations(stock):
    st.header('What is for future')
    st.write(stock.recommendations)
    st.write(stock.recommendations_summary)
    st.write(stock.upgrades_downgrades)



if options == 'stock statistic':
    stats(hist)

elif options == 'stock data':
    show_data_from_last_five_day(hist)

elif options == 'plot data':
    plot_data(hist)

elif options == 'Income Statement':
    income_statement(ticker)

elif options == 'Balance Sheet':
    balance_sheet(ticker)

elif options == 'Cash Flow':
    cash_flow(ticker)

elif options == 'Holdings':
    holding(ticker)

elif options == 'Major Transaction':
    major_transaction(ticker)

elif options == 'Recommendations':
    recommendations(ticker)
