this.fake_witchhunter_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.fake_witchhunter";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous tombez sur un homme entouré d\'une foule de paysans ivres et en colère. L\'homme cerné porte un chapeau noir et un arbalète prête à tirer. Tout près se trouve un bûcher muni d\'un poteau et des attaches auxquelles il manque quelqu\'un à enchaîner. La foule crie et hurle et à travers leurs crachats et leur écume, on comprend ce qui s\'est passé: la ville a engagé un chasseur de sorcières et, comme l\'explique un paysan agressif, le chasseur a trouvé la sorcière et a décidé qu\'elle n\'était pas du tout une sorcière et l\'a laissée partir. Le paysan trébuche, presque en pleurant.%SPEECH_ON%Ce n\'est pas juste, ce n\'est pas juste. Nous avons construit ce bûcher et tout le reste pour que le feu fasse son œuvre. Ce n\'est pas juste, mais on va arranger ça. Parce qu\'il est certain que nous allons brûler quelque chose de mauvais!%SPEECH_OFF%La foule rugit. Il semble que ce supposé chasseur de sorcières ait commis l\'un des pires crimes qui soient: ennuyer les laïcs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous devons intervenir.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "%witchhunter%, Vous connaissez cet homme?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Cela ne nous concerne pas.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous vous avancez et expliquez ce qu\'est un accord. Si le village a engagé l\'homme pour tuer une sorcière alors qu\'elle n\'en était pas une, alors il ne peut pas la tuer. S\'il le faisait quand même, ce serait uniquement pour une histoire de couronnes. S\'il décidait de ne pas la tuer et que le village annulait son accord, il serait alors contraint de faire tout simplement ce que lui demande chaque village pour éviter que cette situation ne se reproduise. En expliquant calmement, vous dites au village qu\'il risque de montrer à tous qu\'ils ne sont pas dignes de confiance, et qu\'en vertu de l\'exemple qu\'ils donnent, ils ne seront approchés que par des charlatans et des mécréants qui visent leur or et non l\'accomplissement d\'une tâche demandée. Et le refus du chasseur de brûler un innocent montre la force de son caractère.\n\nLorsque vous avez terminé, la foule est en grande partie d\'accord, mais quelqu\'un dit alors: \"Brûlez-le quand même !\", c'est alors que tout le monde se met en colère. Cependant, en se retournant, ils découvrent que le chasseur de sorcières s\'est échappé pendant que vous faisiez votre discours. Les paysans commencent à s\'accuser mutuellement de ne pas l\'avoir surveillé. Les disputes se transforment rapidement en bagarres, ce qui vous force à partir. Quand vous arrivez à la sortie de la ville, vous tombez sur la star du jour. Il vous remercie en vous offrant un certain nombre de couronnes. Vous trouvez très inhabituel qu\'un homme se sépare de son argent alors qu\'il aurait pu simplement partir. Il incline son chapeau noir et dit qu\'il ne fait pas cette chasse aux sorcières pour l\'argent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel homme étrange.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(75);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]75[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Vous vous avancez en criant et en agitant les mains. La foule se calme lentement et se retourne pour vous écouter. En choisissant soigneusement vos mots, vous expliquez qu\'il y a un commerce dans les affaires honnêtes, que si quelqu\'un paie des couronnes pour engager quelqu\'un, et qu\'il tourne le dos à cette personne à cause d\'un changement de situation, alors il ne fait que s\'ériger en individu indigne de confiance avec lequel personne ne voudra traiter, et avant que vous ne puissiez terminer votre discours, quelqu\'un lance une pierre juste au-dessus de votre tête et un autre homme court en criant et plante une fourche dans la poitrine du chasseur de sorcières. Cette dernière action entraine le chaos le plus total, vous et la compagnie %companyname% fuyez en repoussant les paysans enragés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Putain de paysans.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_141.png[/img]{%witchhunter% se présente. Il dit que l\'homme au chapeau noir est un fraudeur connu dans le milieu de la chasse aux sorcières.%SPEECH_ON%Nous recherchons cet homme depuis un certain temps car ses mensonges souillent le nom de notre profession. J\'ai longtemps cherché une occasion d\'obtenir son scalp.%SPEECH_OFF%Avant que vous ne puissiez dire un mot de plus, %witchhunter% attrape une fourche qui appartenait à un paysan et traverse la foule à toutes jambes. Il fini par l\'enfoncer promptement dans la jambe du faux chasseur de sorcières. L\'homme se penche en hurlant. Le faux chasseur arme son arbalète, mais %witchhunter% l\'attrape par le canon afin que le tir parte vers le ciel. Il arrache l\'arbalète en hurlant qu\'elle ne lui appartient pas et annonce à la foule que l\'homme est un charlatan. Il le jette à terre, en disant à la foule de faire ce qu\'elle veut. Ils se jettent sur le menteur, bien qu\'il soit difficile de pouvoir discerner quoi que ce soit du lynchage en cours, %witchhunter% revient avec l\'arbalète, la tournant dans un sens puis dans l\'autre. C\'est l\'arme la plus incroyable que vous ayez vue depuis longtemps. Le chasseur de sorcières vous la présente.%SPEECH_ON%Il appartenait à un maître de guilde de la région. Nous pensons que ce fou l\'a assassiné, a pris ses vêtements et se promène depuis en faisant semblant. Si ses cris vous dérangent, capitaine, rappelez-vous qu\'il a brûlé d\'innombrables innocents et volé d\'innombrables couronnes à des gens désespérés et paumés. Qu\'il aille se faire voir.%SPEECH_OFF%Vous regardez fixement l\'homme et la foule. Vous pouvez tout juste distinguer l\'homme que l\'on hisse sur le bûcher et la fumée des premiers feux qui s\'allument.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_crossbow");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Alors que le lynchage est la forme de divertissement préférée des paysans, vous sentez un certain danger dans l\'air. La compagnie %companyname% se déplace à la périphérie de la ville. Vous ne savez jamais à quel moment cela va partir en bagarre générale.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On se casse.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				foundTown = true;
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_witchhunter = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter" && bro.getLevel() >= 4)
			{
				candidates_witchhunter.push(bro);
			}
		}

		if (candidates_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidates_witchhunter[this.Math.rand(0, candidates_witchhunter.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});

