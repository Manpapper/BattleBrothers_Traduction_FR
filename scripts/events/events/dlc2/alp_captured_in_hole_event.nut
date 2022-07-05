this.alp_captured_in_hole_event <- this.inherit("scripts/events/event", {
	m = {
		Beastslayer = null
	},
	function create()
	{
		this.m.ID = "event.alp_captured_in_hole";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 170.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous trouvez un homme assis près d\'un trou dans le sol. À côté de lui, il y a un pieu en métal auquel est attachée une chaîne qui s\'enfonce dans le trou. Le trou est recouvert de peau de chèvre. Il vous salue d\'un signe de la main, mais dit que si vous voulez le voir, il faudra payer. Vous lui demandez ce qu\'il a. Il sourit.%SPEECH_ON%La chose la plus étrange, monsieur.%SPEECH_OFF%Quelques hommes armés se tiennent à l\'écart, faisant sans doute partie du jeu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, je vais payer un peu juste pour voir.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "On en reste là.",
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
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous tendez quelques pièces à l\'homme. Il les mord à pleines dents et vous lui dites de se méfier, il y a du sang sur certaines d\'entre elles. Il hausse les épaules et empoche l\'argent. Vous arrivez au trou et l\'homme enlève les peaux de chèvre. Un alp à l\'allure effroyable vous regarde et siffle avec des rangées de dents pointues et un visage semblable à un pâle rideau de chair. Il a une manille autour du cou et la créature l\'a siffle comme si c\'était la première fois qu\'il la voyait là.%SPEECH_ON%C\'est une horrible petite bête, n\'est-ce pas ? Ne vous approchez pas trop, il vous fera voir des choses. Sauf si vous en avez envie, bien sûr. Certaines personnes le font. Mais si vous commencez à voir des choses et que vous appréciez, alors vous devez payer un peu plus!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous devriez le tuer.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Très bien, euh, bonne chance alors.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = -10;
				this.World.Assets.addMoney(-10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Des créatures aussi hideuses ne peuvent pas continuer à survivre. Vous dites à l\'homme qu\'il est probable qu\'il sorte du trou à un moment donné et qu\'il commence à faire des ravages dans le monde, si ce n\'est bien plus par vengeance. L\'homme crache.%SPEECH_ON%Va te faire foutre. Sortez d\'ici et vous ne récupérerez pas votre argent. Vous faites un seul faux pas et je devrai me défendre et protéger mon investissement. C\'était une vraie saloperie de capturer cette chose, vous savez?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais le tuer moi-même.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Bien, laisse-le vivre.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, vous êtes un expert de ces choses. Qu\'en dites vous?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous prenez la lance d\'un des gardes et la balancez dans la fosse, frappant l\'alp en plein tête. Sa chair pâle se dégonfle autour du manche de la lance comme si vous aviez frappé un énorme rideau. L\'esclavagiste sort une dague et va vous poignarder. %randombrother% pare le coup et tranche la gorge de l\'homme. Quelques gardes plongent dans la mêlée, tous meurent rapidement, mais quelques mercenaires sont blessés dans la bagarre. Une fois la confrontation terminée, vous récupérez l\'or que l\'esclavagiste avait sur lui. Vous faites jeter les corps dans le trou avec l\'alp mort, puis vous le rebouchez.}",
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
				local money = this.Math.rand(25, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous n\'allez pas vous embêter à vous disputer avec ces hommes. Certains des meilleurs combattants que vous avez vus se sont fait tuer dans des bagarres de bar irréfléchies et sans intérêt. Si ces idiots veulent garder le monstre, qu\'il en soit ainsi. Mais quelques mercenaires de la compagnie ne sont pas heureux à l\'idée qu\'un alp soit autorisé à vivre, d\'autant plus que la créature a fixé son regard sans visage sur un certain nombre d\'entre eux et a semblé faire un signe de tête comme si elle allait les revoir plus tard.}",
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
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(0.75, "You let some alp live which may haunt the company later");

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
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_122.png[/img]{%beastslayer% le tueur de bêtes marche jusqu\'au trou et le regarde. Il hoche la tête.%SPEECH_ON%Vous ne l\'avez pas capturé. Les Alps ne peuvent pas être capturées.%SPEECH_OFF%L\'esclavagiste regarde et demande comment ça se passe. Le tueur rit.%SPEECH_ON%Parce que ce n\'est pas une créature ordinaire. Cet alp attend son heure. Vous avez dit qu\'il envoie des cauchemars aux gens qui regardent à l\'intérieur, hein? Oui, c\'est ça. La peur est sa lame et elle l\'aiguise bien et régulièrement. Les Alpes utilisent certains environnements pour y mettre leurs victimes et en ce moment, ils se contentent de la terre.  Mais vous finirez par le regarder à l\'intérieur et il regardera vers le haut, prêt à faire sa sale besogne, et vous vous retrouverez dans le trou avec lui. Pas vous, pas vous-même. Non, le corps serait épargné. Il emmènera votre esprit dans ce trou. Et il sera là. Vous et cette monstruosité, seuls ,dans toute la noirceur que ce monde a à offrir. Pour combien de temps ? Des jours, des semaines. Un alp très dangereux peut emprisonner votre esprit pendant ce qui semble être des années. Vous en sortirez trompé, brisé, bavant et suppliant la mort de venir, si vous êtes encore capable de parler.%SPEECH_OFF%Le tueur de bête emprunte l\'arc d\'un des gardes de l\'esclavagiste. Il encoche une flèche. L\'alp regarde en l\'air et sa bouche s\'ouvre sur des rangées de dents acérées comme des rasoirs. Le tueur de bêtes lui tire dessus en plein dans la gueule, le tuant sur le coup. Il rend l\'arc et déplie une feuille remplie de chiffres.%SPEECH_ON%C\'est le salaire qui m\'est dû. Un supplément pour avoir sauvé votre âme et votre esprit de la récolte éternelle d\'un alp. Je vais aussi prendre la peau de l\'alp. Vous êtes d\'accord?%SPEECH_OFF%L\'esclavagiste hoche rapidement la tête.%SPEECH_ON%Oui, oui, bien sûr!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous partagerez cela avec la compagnie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				local money = 25;
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local item = this.new("scripts/items/misc/parched_skin_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days < 30)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad || currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_beastslayer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.Beastslayer ? this.m.Beastslayer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Beastslayer = null;
	}

});

