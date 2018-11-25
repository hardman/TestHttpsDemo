#!/bin/sh

locale='CN'
province='Beijing'
city=$province
company='xxx'
unit='yyy'
hostname='127.0.0.1'
email='hr@suning.com'

#clean
function clean(){
	echo '清理文件...'
	ls | grep -v create.sh | xargs rm -rf
}

#用法
function usage(){
	echo 'usage: ./create.sh 
		[-l [localevalue]]
		[-p [provincevalue]]
		[-c [cityvalue]]
		[-d [companyvalue]]
		[-u [unitvalue]]
		[-h [hostnamevalue]]
		[-e [emailvalue]]
	'
	exit
}

#参数
if [ $# -gt 0 ]; then
	while getopts "cl:p:c:d:u:h:e" arg;
	do
		case $arg in
			c)
				clean && exit
				;;
			l)
				locale=$OPTARG
				;;
			p)
				province=$OPTARG
				;;
			c)
				city=$OPTARG
				;;
			d)
				company=$OPTARG
				;;
			u)
				unit=$OPTARG
				;;
			h)
				hostname=$OPTARG
				;;
			e)
				email=$OPTARG
				;;
			?)
				usage
				;;
		esac
	done
fi

clean

echo '开始创建根证书...'

openssl genrsa -out ca-private-key.pem 1024
openssl req -new -out ca-req.csr -key ca-private-key.pem <<EOF
${locale}
${province}
${city}
${company}
${unit}
${hostname}
${email}

EOF
openssl x509 -req -in ca-req.csr -out ca-cert.pem -outform PEM -signkey ca-private-key.pem -days 3650
openssl x509 -req -in ca-req.csr -out ca-cert.der -outform DER -signkey ca-private-key.pem -days 3650
openssl pkcs12 -export -clcerts -in ca-cert.pem -inkey ca-private-key.pem -out ca-cert.p12

echo '开始创建服务端证书...'

openssl genrsa -out server-private-key.pem 1024
openssl req -new -out server-req.csr -key server-private-key.pem << EOF
${locale}
${province}
${city}
${company}
${unit}
${hostname}
${email}

EOF
openssl x509 -req -in server-req.csr -out server-cert.pem -outform PEM -signkey server-private-key.pem -CA ca-cert.pem -CAkey ca-private-key.pem -CAcreateserial -days 3650
openssl x509 -req -in server-req.csr -out server-cert.der -outform DER -signkey server-private-key.pem -CA ca-cert.pem -CAkey ca-private-key.pem -CAcreateserial -days 3650
openssl pkcs12 -export -clcerts -in server-cert.pem -inkey server-private-key.pem -out server-cert.p12

echo '开始创建客户端证书...'

openssl genrsa -out client-private-key.pem 1024
openssl req -new -out client-req.csr -key client-private-key.pem << EOF
${locale}
${province}
${city}
${company}
${unit}
${hostname}
${email}

EOF
openssl x509 -req -in client-req.csr -out client-cert.pem -outform PEM -signkey client-private-key.pem -CA ca-cert.pem -CAkey ca-private-key.pem -CAcreateserial -days 3650
openssl x509 -req -in client-req.csr -out client-cert.der -outform DER -signkey client-private-key.pem -CA ca-cert.pem -CAkey ca-private-key.pem -CAcreateserial -days 3650
openssl pkcs12 -export -clcerts -in client-cert.pem -inkey client-private-key.pem -out client-cert.p12

echo 'finishied'