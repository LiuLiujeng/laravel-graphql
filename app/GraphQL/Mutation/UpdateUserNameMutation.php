<?php
namespace App\GraphQL\Mutation;

use GraphQL;
use GraphQL\Type\Definition\Type;
use Folklore\GraphQL\Support\Mutation;
use App\User;

class UpdateUserNameMutation extends Mutation
{
    protected $attributes = [
        'name' => 'updateUserName',
    ];

    public function type()
    {
        return GraphQL::type('User');
    }

    public function args()
    {
        return [
            'id' => ['name' => 'id', 'type' => Type::nonNull(Type::int())],
            'name' => ['name' => 'name', 'type' => Type::nonNull(Type::string())]
        ];
    }

    public function rules()
    {
        return [
            'id' => ['required'],
            'email' => ['required', 'email']
        ];
    }

    public function resolve($root, $args)
    {
        $user = User::find($args['id']);

        if (!$user) {
            return null;
        }

        $user->name = $args['name'];
        $user->save();

        return $user;
    }
}
