this.sellsword_gets_better_deal_event <- this.inherit("scripts/events/event", {
	m = {
		Sellsword = null,
		Amount = 0,
		OldPay = 0
	},
	function create()
	{
		this.m.ID = "event.sellsword_gets_better_deal";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Pendant que vous faites l\'inventaire, %sellsword% se joint à vous, tripotant sans réfléchir cette épée ou ce bouclier. Vous posez votre plume et lui demandez ce qu\'il y a, car il n\'est sûrement pas là pour compter quoi que ce soit. Il explique qu\'une autre compagnie souhaite utiliser son épée - et qu\'elle est prête à payer plus. Vous demandez combien et il lève les mains pour compter.%SPEECH_ON%Ils parlent de %newpay% couronnes par jour.%SPEECH_OFF%Il gagne %pay% couronnes par jour avec vous.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vois, il est temps de se séparer alors.",
					function getResult( _event )
					{	
						_event.m.Sellsword.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.Sellsword);
						return 0;
					}

				},
				{
					Text = "Il doit y avoir un moyen de te convaincre de ne pas faire ça.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= _event.m.Sellsword.getLevel() * 10 ? "B" : "C";
					}

				},
				{
					Text = "Alors j\'égalerai leur offre.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img] Vous vous retournez, croisant les bras et posant une botte contre une caisse. Le regard fixé sur la terre, vous dites à %sellsword% que la compagnie a traversé beaucoup de choses ensemble et que tout le monde, vous en particulier, détesterait le voir partir. Il a une seconde famille ici avec %companyname% et c\'est une chose rare dans le monde des mercenaires. Là où il va, il n\'y a aucune garantie de ce qu\'il peut trouver. Vous le savez, parce que vous avez été là. Vous avez été à sa place, et vous avez pris ces chaussures et marché. Et vous l\'avez regretté. Le mercenaire regarde le sol, réfléchissant à vos paroles. Finalement, il hoche la tête et accepte de rester. Vous lui dites qu\'il a fait le bon choix. L\'homme se retourne et tapote un carquois de flèches tout en s\'éloignant.%SPEECH_ON%Vous pourriez vouloir le remplir à nouveau.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Content que tu restes avec nous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				_event.m.Sellsword.getFlags().add("convincedToStayWithCompany");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_16.png[/img] Vous vous retournez, croisant les bras et posant une botte contre une caisse. Le regard fixé sur la terre, vous dites à %sellsword% que la compagnie a traversé beaucoup de choses ensemble et que tout le monde, vous en particulier, détesterait le voir partir. Il a une seconde famille ici avec %companyname% et c\'est une chose rare dans le monde des mercenaires. Là où il va, il n\'y a aucune garantie de ce qu\'il peut trouver. Vous le savez, parce que vous avez été là. Vous avez été à sa place, et vous avez pris ces chaussures et marché. Et vous l\'avez regretté. Le mercenaire regarde le sol, réfléchissant à vos paroles. Finalement, il secoue la tête et pince les lèvres d\'un air \"désolé\". Vous lui dites qu\'il fait le mauvais choix, mais il ne veut rien entendre. L\'homme se retourne et tapote un carquois de flèches en s\'éloignant. %SPEECH_ON%Vous pourriez le remplir à nouveau.%SPEECH_OFF%Les flèches sont un peu faibles, mais tout ce à quoi vous pensez est de trouver comment remplacer un bon épéiste comme lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est vraiment dommage.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sellsword.getName() + " quitte " + this.World.Assets.getName()
				});
				_event.m.Sellsword.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Sellsword.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Sellsword);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img] Vous soupirez. L\'homme hoche la tête et commence à partir, mais vous l\'arrêtez. Vous allez payer la somme pour qu\'il puisse rester. %companyname% ne peut tout simplement pas se permettre de perdre un homme comme lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un homme bon n\'est pas donné.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				_event.m.Sellsword.getBaseProperties().DailyWage += _event.m.Amount;
				_event.m.Sellsword.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Sellsword.getName() + " est maintenant payé " + _event.m.Sellsword.getDailyCost() + " Courrones par jour"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 4 && bro.getLevel() <= 9 && this.Time.getVirtualTimeF() - bro.getHireTime() > this.World.getTime().SecondsPerDay * 25.0 && bro.getBackground().getID() == "background.sellsword" && !bro.getFlags().has("convincedToStayWithCompany"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Sellsword = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Amount = this.Math.rand(5, 15);
		this.m.OldPay = this.m.Sellsword.getDailyCost();
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sellsword",
			this.m.Sellsword.getName()
		]);
		_vars.push([
			"newpay",
			this.m.OldPay + this.m.Amount
		]);
		_vars.push([
			"pay",
			this.m.OldPay
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Sellsword = null;
		this.m.Amount = 0;
		this.m.OldPay = 0;
	}

});

