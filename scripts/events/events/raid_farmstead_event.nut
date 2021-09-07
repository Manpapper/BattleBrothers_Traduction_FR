this.raid_farmstead_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy1 = null,
		SomeGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.raid_farmstead";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]%randombrother% vient vous voir avec un état de vos stocks de nourriture. Il explique qu\'il n\'y a pas grand-chose à se mettre sous la dent et que le pain dont vous disposez pourrait être mieux utilisé pour construire une maison ou tuer un homme. La plupart des fruits sont mous au toucher, recouverts de ce qui semble être une fourrure grise. Tout ce qui reste a été jeté dans un grand ragoût que les hommes ont judicieusement appelé \"bouillon d\'entrejambe\". Pour être franc, ça ne se présente pas bien.\n\nCependant, par une coïncidence fortuite, une petite ferme se trouve au loin. Le frère d\'arme ne le dit pas franchement, mais il suggère gentiment que la compagnie pourrait peut-être y faire une descente.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On fait une descente.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "On continue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Vous vous dirigez vers la ferme. Quelques fermiers se redressent dans les champs, vous dévisagent à votre approche et échangent des regards entre eux. Un fermier qui met le foin en balle plante sa fourche dans le sol et tend ses mains au-dessus. Ils vous observent tous avec une curiosité nerveuse alors que vous traversez les plaines, vos hommes n\'essayant pas du tout de cacher leur envie de voir les récoltes qui passent.\n\nQuand vous vous approchez de la ferme, une femme vient à votre rencontre Elle s\'essuie le front et demande ce que vous voulez. Quelques enfants sortent d\'une maison voisine et se tiennent sur le porche. Ils vous regardent timidement derrière les jambes d\'un homme plus âgé, probablement le père de la femme.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ne prenez que ce qui est nécessaire.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Prenez tout.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Prenez tout. Tuez tout le monde.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]Tu expliques à la femme que tes hommes ont besoin de nourriture. Elle halète, mais vous levez la main.%SPEECH_ON%Nous ne prendrons que ce dont nous avons besoin, ni plus, ni moins. Nous ne voulons pas d\'ennuis, et je sais que vous n\'en voulez pas non plus. N\'est-ce pas ? %SPEECH_OFF% La femme acquiesce rapidement. Vous vous retournez et ordonnez à vos hommes de prendre quelques vivres, tandis qu\'au même moment la femme hausse le ton et demande aux fermiers de ne pas faire de bêtises. L\'affaire dure une dizaine de minutes avant que votre groupe ne reprenne la route.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il fallait le faire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_72.png[/img]La nourriture ici est abondante. Vous vous retournez vers vos hommes et leur dites de prendre tout ce qu\'ils peuvent. Haletante, la femme recule et semble prête à crier. Vous l\'attrapez, ce qui provoque une série de cris de la part des enfants. Quelques fermiers saisissent des faucilles et des fourches à leur tour. Vous lui dites d\'ordonner au reste des fermiers de poser leurs armes au sol. Elle obéit, et les fermiers font ce qu\'on leur dit, bien qu\'avec réticence.\n\nVous tenez la femme pendant que vos hommes prennent ce qu\'ils peuvent. Quand ils ont pillé tout ce qu\'ils pouvaient porter, vous la laissez partir et vous ordonnez à vos hommes de partir.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous le méritons bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/goat_cheese_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_30.png[/img]Il y a beaucoup de nourriture ici. Et trop de témoins.\n\nVous vous retournez et lancez un regard complice à %someguy1%. Il acquiesce et encoche une flèche. Avant que la femme n\'ait le temps de crier, le mercenaire tire et le vieil homme sous le porche titube à reculons dans la maison, suivi des d\'enfants qui hurlent. Le reste de votre compagnie se disperse, dégainant leurs épées en courant dans les champs. Quelques fermiers tentent de se défendre, mais votre groupe bien armé ne leur fait pas de cadeau. %someguy2% saute dans la maison et à l\'intérieur, vous entendez des cris qui, un par un, disparaissent jusqu\'au silence. Vous remettez la femme à quelques mercenaires, en leur disant de s\'assurer qu\'elle est bien morte avant de partir. Quelques autres mercenaires commencent immédiatement à couper les cultures et à voler des objets dans la maison. Très vite, vous êtes de retour sur les routes, vos stocks étant maintenant presque pleins. Quelques frères portent des chiffons rouges à leurs lames mouillées.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il ne reste plus personne pour raconter ce qui s\'est passé ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-5);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/goat_cheese_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				this.World.Assets.updateFood();

				for( local i = 0; i < this.Math.rand(1, 2); i = ++i )
				{
					local pitchfork = this.new("scripts/items/weapons/pitchfork");
					this.World.Assets.getStash().add(pitchfork);
					this.List.push({
						id = 10,
						icon = "ui/items/" + pitchfork.getIcon(),
						text = "Vous recevez a " + pitchfork.getName()
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty"))
					{
						bro.improveMood(1.0, "A apprécié les raids et les pillages");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "A été choqué par la conduite de la compagnie.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Farmland)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getFood() > 50)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bloodthirsty") || !bro.getBackground().isOffendedByViolence())
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local x = 0;
		local y = 0;

		while (x == y)
		{
			x = this.Math.rand(0, candidates.len() - 1);
			y = this.Math.rand(0, candidates.len() - 1);
		}

		this.m.SomeGuy1 = candidates[x];
		this.m.SomeGuy2 = candidates[y];
		this.m.Score = 30;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"someguy1",
			this.m.SomeGuy1.getName()
		]);
		_vars.push([
			"someguy2",
			this.m.SomeGuy2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.SomeGuy1 = null;
		this.m.SomeGuy2 = null;
	}

});

