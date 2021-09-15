this.travelling_monk_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.travelling_monk";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_40.png[/img]Vous rencontrez un moine sur les routes accompagné d\'une charrette tirée par un âne, le pauvre animal de trait se déplace avec la tête basse en signe d\'épuisement. De la paille et de la mousse sont accrochés à un côté de la charrette, se tordebnt avec ardeur dans le vent même qui les a séchés, il y a aussi quelques pots et casseroles qui s\'entrechoquent comme des carillons rustiques lorsque les modestes marchandises s\'arrêtent. Un tonneau vacille sur le bord de la charrette et un couple d\'abeilles se balance pour le suivre, picorant ses fentes avec une curiosité assoiffée.\n\nLe moine soulève un bonnet de laine pour le dégager de son visage, mais le rebord se rabat sur ses yeux. Il l\'enlève complètement et passe une manche sur son front. Affichant un sourire jovial, il ne semble pas du tout perturbé par la véritable armurerie vivante qui se tient devant lui.%SPEECH_ON%Bonsoir messieurs. Je n\'ai pas l\'impression que vous êtes du genre à marcher sous la bannière d\'un seigneur. Vous ressemblez plutôt à des mercenaires pour moi.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Qu\'est-ce que vous transportez ?",
					function getResult( _event )
					{
						return "A2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_40.png[/img]%SPEECH_ON%Oui, je savais que vous demanderiez ça. Voici Bessie, un nom de vache pour un âne. Ne vous inquiétez pas, elle ne va pas vous frapper. Elle est toute cravatée, vous voyez ? Ce qu\'elle transporte, eh bien, c\'est de la bière. Pour les hommes là-bas, afin qu\'ils puissent boire aux hommes décédés. Si ça ne vous dérange pas, ou si ça ne vous dérange pas pour mes affaires, j\'aimerais continur mon chemin.%SPEECH_OFF%Le moine prend les rênes de son jenny et se prépare à partir.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Combien de couronnes pour une tournée de bière ?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "D";
					}

				},
				{
					Text = "Nous l\'avons mérité en gardant les routes sûres - prenez la bière, les gars !",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]Vous levez la main, arrêtant le moine avant qu\'il ne puisse repartir. Il soupire et retire lentement les rênes de sa main. Ayant l\'impression qu\'il se fait des idées, vous lui demandez rapidement s\'il n\'aurait pas de la bière pour vos hommes. Vous êtes plus que prêt à payer. Le moine regarde son stock un moment, puis se retourne.%SPEECH_ON%Oui. Je donne à vos hommes une gorgée pour une couronne ou deux. Ne faites pas attention aux abeilles autour du dessus, elles détaleront quand vous arriverez, mais si vous détalez quand elles détalent, elles vous poursuivront. Drôles de petites bêtes.%SPEECH_OFF% Vous demandez à l\'homme combien il veut.%SPEECH_ON% Je dirait que 10 couronnes par tête feront l\'affaire. Je ne suis pas un homme d\'affaire, je pourrais profiter de moi-même ici.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une tournée pour toute la compagnie !",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Vous en demandez trop.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_40.png[/img]Vous acceptez de payer à l\'homme ce qu\'il a demandé et il ouvre son bras en signe d\'invitation. Vos hommes soulèvent le couvercle du tonneau et plongent leurs gobelets dedans. Ils viennent s\'asseoir à l\'ombre, sirotant des tankards et échangeant des bières. Le moine vous fait ses adieux et les hommes lui lèvent tous leur coupe dans une acclamation bruyante et de plus en plus bredouillante.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Santé !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-10 * this.World.getPlayerRoster().getSize());
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 10 * this.World.getPlayerRoster().getSize() + "[/color] Couronnes"
					}
				];
				this.List.extend(_event.giveTraits(90));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]Vous levez la main, arrêtant le moine avant qu\'il ne puisse repartir. Il soupire et retire lentement les rênes de sa main. Ayant l\'impression qu\'il se fait des idées, vous lui demandez rapidement s\'il n\'aurait pas de la bière pour vos hommes. Vous êtes plus que prêt à payer. Le moine regarde son stock pendant un moment, puis se retourne.%SPEECH_ON%Oui. Que les dieux soient maudits s\'ils ne sont pas contents que ton argent croise leurs paumes. Si vous vous battez pour le bon côté, vous pouvez en prendre un peu gratuitement, mais pas tout bien sûr%SPEECH_OFF% Vous remerciez le moine pour sa générosité et vous ordonnez à vos hommes d\'être modestes dans leur consommation. Alors que quelques frères tournent autour du tonneau, le moine lève les mains en l\'air.%SPEECH_ON%Ne faites pas attention aux abeilles autour du sommet, elles détaleront quand vous arriverez, mais si vous détalez quand elles détalent, elles vous poursuivront. Drôles de petites bêtes.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Santé !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveTraits(90);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]Alors que la charrette passe, vous prenez le pommeau de votre épée et le frappez contre le tonneau de bière, faisant sauter le couvercle et mettant un certain nombre d\'abeilles en émoi. Le moine lâche les rênes en se retournant vers toi.%SPEECH_ON%J\'avais peur que vous ne fassiez ça.%SPEECH_OFF%L\'homme disparaît sous un coup de poing, son corps se tord en tombant au sol. Quelques frères convergent vers lui pour lui donner de bons coups de pied tandis que d\'autres soulèvent la bière et la portent à l\'ombre. Vous plongez une chope dans le tonneau pour boire un coup puis vous la portez au moine qui se tortille sur le sol.%SPEECH_ON%Cul sec les gars, et n\'oublions pas de remercier notre généreux ami là-bas!%SPEECH_OFF%Le moine se retourne, les yeux grimaçants car ils clignent rapidement. Il se tient le dos d\'une main et utilise l\'autre pour se relever lentement. La posture courbée, il prend les rênes de l\'âne et se met en marche. Il essaie de remettre son chapeau, mais celui-ci tombe et il ne prend pas la peine de le chercher. L\'homme se fait petit au loin, brouillé par l\'horizon et l\'alcool, puis il disparaît.\n\nLes hommes lèvent tous leur coupe vers vous dans une acclamation bruyante et de plus en plus brouillonne.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Santé !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				this.List = _event.giveTraits(66);
			}

		});
	}

	function giveTraits( _chance )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];

		foreach( bro in brothers )
		{
			if (this.Math.rand(1, 100) <= _chance)
			{
				bro.improveMood(1.0, "Celebrated with the company");

				if (bro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					result.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}
		}

		return result;
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 10 * this.World.getPlayerRoster().getSize() + 250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A1";
	}

	function onClear()
	{
	}

});

