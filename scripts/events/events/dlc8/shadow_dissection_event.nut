this.shadow_dissection_event <- this.inherit("scripts/events/event", {
	m = {
		Talkers = [],
		Anatomist = null,
		Cultist = null,
		Monk = null,
		Mercenary = null,
		Swordmaster = null,
		Minstrel = null,
		OtherBro = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.shadow_dissection";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{La compagnie a établi son camp à côté d\'un prieuré abandonné, les hommes sont assis autour du feu de camp, projetant des ombres animales sur l\'un de ses murs en pierre. D\'abord un lapin, puis un chien haletant, bien sûr l\'oiseau, la tête d\'un serpent et la petite souris pour la manger. L\'un des mercenaires se demande ce que font ces ombres quand ils ne regardent pas. Il lève ses mains, leurs formes noires contre le mur.%SPEECH_ON%Je veux juste dire que nous avons ces choses qui nous suivent partout où nous allons, nous jouons avec elles, vous savez, et pourtant nous n\'y pensons pas vraiment. Je veux dire, regardez ça, qu\'est-ce que c\'est?%SPEECH_OFF%Il écarte les mains et projette dix grosses ombres contre le mur. Les hommes réfléchissent...}",
			Banner = "",
			Characters = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Anatomist != null)
				{
					this.Options.push({
						Text = "Qu\'est-ce que %anatomist% l\'anatomiste a à dire?",
						function getResult( _event )
						{
							return "B";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist% le cultiste murmure à nouveau.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Notre moine %monk% semble vouloir répondre.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Mercenary != null)
				{
					this.Options.push({
						Text = "Pourquoi tout le monde regarde le plus gros mercenaire?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Swordmaster != null)
				{
					this.Options.push({
						Text = "%swordmaster% le maitre d\'armes semble avoir un mot à dire.",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Naturellement, %minstrel% le ménestrel est prêt à parler.",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Killer != null && this.Options.len() < 6)
				{
					this.Options.push({
						Text = "Quel est ce bruit?",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% l\'anatomiste lève les yeux du feu de camp, son visage se tordant d\'ombres à mesure que les flammes montent et descendent.%SPEECH_ON%Nos ombres ne sont que des entailles qui blessent et réparent tout en une seule traînée de noir, disséquant la terre de notre présence d\'une manière si éphémère qu\'elle ne peut être qu\'un aperçu de notre séjour ici. Mais l\'ombre pense-t-elle à vous disséquer? Veut-elle en libérer d\'autres qui lui ressemblent? Elle n\'est sûrement pas seule. Nos entrailles ont sûrement des ombres aussi. Est-ce qu\'elles projettent des illusions d\'elles-mêmes contre nos cloisons intérieures? Quand nous dormons, ces choses sont-elles dressées contre nous de l\'intérieur ou s\'échappent-elles dans le monde pour errer? Sont-elles les gardiennes de notre propre esprit, nous quittant dans la nuit et nous abandonnant aux horreurs des paysages de rêves qui sont présents lorsque nous sommes éveillés? Qu\'est-ce qui distille mieux la vérité de la lumière du matin que notre ombre projetée sur le sol et les souvenirs fugaces de ce qu\'elle est revenue repousser?%SPEECH_OFF%Un des mercenaires le regarde fixement.%SPEECH_ON%Quoi?%SPEECH_OFF%Les autres mercenaires se moquent.%SPEECH_ON%Hé mec, on veut juste faire comme des bites, des salopes et des merdes. Regarde ça, je suis l\'ombre de %anatomist%. Blah blah blah blah!%SPEECH_OFF%L\'homme mime une bouche qui s\'ouvre et se ferme à plusieurs reprises pendant que la compagnie rit.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Au moins l\'anatomiste l\'a pris dans le bon sens",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Anatomist.getID())
					{
						bro.improveMood(0.75, "Felt intellectually superior to the other men");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% le cultist se penche sur le feu, son visage touchant presque les flammes. Les hommes le regardent tandis que ses yeux s\'écarquillent, l\'humidité séchant et se décollant jusqu\'à ce que des veines de sang grossissent sur le blanc. Il se penche en arrière.%SPEECH_ON%Les ombres ne sont que les ambassadeurs d\'une plus grande obscurité.%SPEECH_OFF%Le feu de camp crépite et l\'ombre de l\'homme se dessine contre le mur du prieuré. Pendant un instant, la compagnie voit quelque chose d\'autre dans ce noir intense, quelque chose de tordu et de penché, une entité qui n\'est pas du tout aux ordres du %cultist%. Lorsque les feux s\'éteignent, l\'ombre se brise et s\'éloigne dans la nuit noire. Seule la propre ombre du cultiste demeure, vacillant de manière incertaine contre les murs du prieuré.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Des ombres étranges pour une nuit étrange.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(1.5, "Davkul awaits");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1.0, "Unnerved by " + _event.m.Cultist.getName());

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Debout, %monk% le moine lance un appel aux anciens dieux. Il porte une main à sa poitrine tandis que l\'autre se dresse en hauteur, comme dans une grande offrande oratoire.%SPEECH_ON%Ce ne sont pas les ombres qui doivent nous préoccuper, mais le feu qui les a produites, car c\'est la flamme que les dieux nous ont accordée, de sorte que nous puissions porter le jour dans la nuit, rendre nos habitudes productives sans fin et notre allégeance à ce qui est bon infaillible.%SPEECH_OFF%Les hommes crient: \"écoutez, écoutez!\"}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Puissent-ils veiller sur nous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Inspired by " + _event.m.Monk.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_82.png[/img]{L\'un des mercenaires se lève, pointe du doigt le feu de camp et annonce que %mercenary% a l\'ombre la plus effrayante de tous. Le grand mercenaire regarde en arrière, comme s\'il était contrarié que son nom soit prononcé à haute voix. Il serre les dents et lève lentement les mains, le reste de la compagnie recule craintivement. %mercenary% fait craquer ses doigts.%SPEECH_ON%C\'est un poulet. Vous voyez?%SPEECH_OFF%Les hommes regardent les ombres sur le mur. Cela ne ressemble absolument pas à un poulet, mais personne n\'ose le dire. Ils acquiescent tous et sont d\'accord.%SPEECH_ON%Franchement, %mercenary%, c\'est la plus belle bite que j\'ai jamais vue.%SPEECH_OFF%Les hommes hurlent de rire. Lorsque %mercenary% se lève, les rires cessent.%SPEECH_ON%J\'ai dit que c\'était un poulet, ok?%SPEECH_OFF%L\'autre homme hoche rapidement la tête et convient qu\'il s\'agit bien d\'un poulet. Les tensions s\'apaisent, mais les jeux d\'ombres sont bel et bien terminés.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Ça ressemblait un peu à un ver pour moi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mercenary.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Mercenary.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.75, "Glad he fights alongside " + _event.m.Mercenary.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Afraid of " + _event.m.Mercenary.getName());

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
			Text = "[img]gfx/ui/events/event_17.png[/img]{%swordmaster% le maître d\'armes acquiesce et lui parle.%SPEECH_ON%J\'ai longtemps pensé à aux ombres. Quand vous vous battez à la lumière du jour, y a-t-il deux batailles en cours? Une de chair et de sang, et l\'autre ressemblant à une trainée noircie? Quand vous tuez un homme, est-ce que vous tuez aussi son ombre, ou est-ce que votre ombre tue la sienne? Que sommes-nous même pour nos propres ombres? Car lorsque je me retrouve dans un combat dans le noir, ce n\'est pas du tout un combat, mais une affaire de non-sens, de membres qui volent, d\'épées qui tranchent. La cécité se manifeste. Il semble que ce n\'est que lorsqu\'une ombre est visible que nous pouvons vraiment dire que c\'est un combat d\'hommes.%SPEECH_OFF%Un des mercenaires lève son verre.%SPEECH_ON%Quoi qu\'il en soit, que mon ombre ne croise jamais la vôtre, %swordmaster%.%SPEECH_OFF%Tous les membres de la compagnie lève leur verre. Oyez, oyez!}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Ses ombres se déplacent avec un grand danger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Swordmaster.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Glad he fights with " + _event.m.Swordmaster.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "G",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%minstrel% le ménestrel se lève, la tête penchée sur le côté, la démarche traînante, les yeux fixés sur son ombre située contre le mur du prieuré. Il fixe l\'ombre comme si il s\'agissait de son propre corps et qu\'il était à deux doigts de résoudre son propre meurtre. Soudain, il se redresse d\'un coup, les mains sur les hanches.%SPEECH_ON%Par les dieux, j\'ai tout compris! Mon ombre est un coureur de jupons! Il a un gros marteau dans son pantalon et chaque femme est un clou! C\'est un coureur de jupons! Un ivrogne, un sot pitoyable. Et... et un voleur! Il ne peut pas résister à l\'envie de voler des couronnes à des gens répugnants. Un petit farceur, un petit rat plein de malices. L\'autre jour, mon ombre a chié dans la botte de %othersellsword%! Je n\'en reviens pas!%SPEECH_OFF%%othersellsword% saute sur place, mettant des coups de pied dans le feu, les hommes se mettent à rire. Il s\'avance.%SPEECH_ON%Je savais que ce n\'était pas une putain de merde, espèce de bâtard! Quel genre d\'homme chie dans les bottes d\'un autre?%SPEECH_OFF%Le mercenaire glisse et tombe, ce qui suscite les applaudissements de la compagnie. Le ménestrel s\'éloigne doucement, son ombre lui disant au revoir avec un baiser et un signe de la main.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "L\'ombre du ménestrel est plus active que moi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Minstrel.getID() || bro.getID() == _event.m.OtherBro.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "H",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Alors que les hommes s\'agitent en faisant des ombres, %killer%, le tueur en cavale, s\'approche du camp en portant des cargaisons de bijoux et d\'autres objets, dont les métaux brillent d\'un éclat cramoisi. Il murmure puis s\'arrête soudainement et regarde le reste de la compagnie.%SPEECH_ON%Oh. Vous êtes toujours réveillés? J\'étais juste, euh, dehors. A faire des choses.%SPEECH_OFF%Il y a du sang sur son visage et sous ses ongles. Se sentant en difficulté, il laisse tomber la marchandise.%SPEECH_ON%C\'est pour la compagnie, bien sûr. Je suis juste si, euh, reconnaissant que vous m\'ayez tous accueilli. J\'ai pensé que je devais vous rendre la pareille.%SPEECH_OFF%Les membres de l\'équipe fixent les marchandises. Vous demandez à l\'homme si quelqu\'un va venir chercher ces biens. Il sourit.%SPEECH_ON%Non monsieur, bien sûr que non. Je m\'en suis assuré. Oh capitaine, je m\'en suis assuré, heh, heh, heh.%SPEECH_OFF%Vous dites à l\'homme de mettre les marchandises au stock, mais de s\'assurer de les nettoyer d\'abord. Alors qu\'il s\'éloigne, les autres hommes échangent discrètement des regards. Il n\'y a plus de jeux d\'ombres à l\'ordre du jour, on dirait.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Quelqu\'un pourrait-il garder un œil sur cet homme?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local cultist_candidates = [];
		local monk_candidates = [];
		local mercenary_candidates = [];
		local swordmaster_candidates = [];
		local minstrel_candidates = [];
		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword")
			{
				mercenary_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.swordmaster")
			{
				swordmaster_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrel_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
		}

		local bro;

		if (anatomist_candidates.len() > 0)
		{
			bro = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
			this.m.Anatomist = bro;
			this.m.Talkers.push(bro);
		}

		if (cultist_candidates.len() > 0)
		{
			bro = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
			this.m.Cultist = bro;
			this.m.Talkers.push(bro);
		}

		if (monk_candidates.len() > 0)
		{
			bro = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
			this.m.Monk = bro;
			this.m.Talkers.push(bro);
		}

		if (mercenary_candidates.len() > 0)
		{
			bro = mercenary_candidates[this.Math.rand(0, mercenary_candidates.len() - 1)];
			this.m.Mercenary = bro;
			this.m.Talkers.push(bro);
		}

		if (swordmaster_candidates.len() > 0)
		{
			bro = swordmaster_candidates[this.Math.rand(0, swordmaster_candidates.len() - 1)];
			this.m.Swordmaster = bro;
			this.m.Talkers.push(bro);
		}

		if (minstrel_candidates.len() > 0)
		{
			bro = minstrel_candidates[this.Math.rand(0, minstrel_candidates.len() - 1)];

			do
			{
				this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (this.m.OtherBro == null || this.m.OtherBro.getID() == bro.getID());

			this.m.Minstrel = bro;
			this.m.Talkers.push(bro);
		}

		if (killer_candidates.len() > 0)
		{
			bro = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
			this.m.Killer = bro;
			this.m.Talkers.push(bro);
		}

		if (this.m.Talkers.len() <= 0)
		{
			this.m.Score = 0;
		}
		else
		{
			this.m.Score = 3 * this.m.Talkers.len();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist != null ? this.m.Anatomist.getNameOnly() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"mercenary",
			this.m.Mercenary != null ? this.m.Mercenary.getNameOnly() : ""
		]);
		_vars.push([
			"swordmaster",
			this.m.Swordmaster != null ? this.m.Swordmaster.getNameOnly() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"othersellsword",
			this.m.OtherBro != null ? this.m.OtherBro.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Talkers = [];
		this.m.Anatomist = null;
		this.m.Cultist = null;
		this.m.Monk = null;
		this.m.Mercenary = null;
		this.m.Swordmaster = null;
		this.m.Minstrel = null;
		this.m.OtherBro = null;
		this.m.Killer = null;
	}

});

