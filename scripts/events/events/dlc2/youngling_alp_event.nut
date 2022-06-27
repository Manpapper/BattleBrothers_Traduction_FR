this.youngling_alp_event <- this.inherit("scripts/events/event", {
	m = {
		Callbrother = null,
		Other = null,
		Beastslayer = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.youngling_alp";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%callbrother% entre en courant dans votre tente et dit que quelque chose épie le camp. Vous sortez pour voir une silhouette au loin, se cachant derrière des broussailles et des branches d\'arbres. Vous savez qu\'il vous fixe lorsqu\'il siffle, car que pourrait-il regarder d\'autre pour susciter une telle réaction. Ses bras sont longs et minces et sont prolongés par des griffes. Vous prenez une torche et la lancez vers la bête. Sa peau lisse se teinte alors d\'un orange intense, il s\'éloigne en criant du nuage de braises et d\'étincelles que la torche émet lorsqu\'elle atterrit et roule devant lui. La mâchoire dentée est la dernière chose que vous voyez disparaître dans l\'obscurité.%SPEECH_ON%Je pense que c\'est un alp, monsieur. À priori, il a l\'air seul.%SPEECH_OFF%Vous demandez si le mercenaire a eu des visions. Il hausse les épaules.%SPEECH_ON%Oui, un peu, mais j\'ai bu aussi, voilà.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tuez-le.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ignorez-le.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Callbrother.getImagePath());

				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, Vous êtes un expert de ces choses. Qu\'en dites-vous?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Flagellant != null)
				{
					this.Options.push({
						Text = "Que dit %flagellant% à ce sujet?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_122.png[/img]{L\'alp est seul et probablement jeune. Même les monstres doivent faire des efforts pour devenir des bêtes vraiment horribles, et celui-ci ne semble pas encore en être là. Vous envoyez une paire de mercenaires pour tuer la bête. Ils se rapprochent d\'elle à travers le linceul des ténèbres. Vous voyez les silhouettes se dresser en embuscade, il y a un fracas et un cri, et un autre cri qui n\'a rien d\'humain du tout. Des hurlements maintenant. Et cette fois, un homme qui pleure. Quelqu\'un qui parle. Un silence. Un long, long silence. Puis le duo revient. L\'un d\'eux se tient la tête comme s\'il était pris d\'une terrible douleur, l\'autre vous regarde et acquiesce.%SPEECH_ON%On l\'a tué et, euh, je pense qu\'on doit s\'allonger.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Callbrother.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Callbrother.addXP(200, false);
				_event.m.Callbrother.updateLevel();
				_event.m.Other.addXP(200, false);
				_event.m.Other.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Callbrother.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				_event.m.Callbrother.worsenMood(0.75, "Had an alp invade his mind");

				if (_event.m.Callbrother.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Callbrother.getMoodState()],
						text = _event.m.Callbrother.getName() + this.Const.MoodStateEvent[_event.m.Callbrother.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Other.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				_event.m.Other.worsenMood(0.75, "Had an alp invade his mind");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous dites aux hommes d\'ignorer l\'alp. Si c\'était un danger, il l\'aurait déjà montré. Au contraire, il vous a fait savoir qu\'il était là, que ce soit par ignorance ou par arrogance, ce qui ne vous dérange pas. Quelques hommes ne sont pas d\'accord avec cette décision et restent debout toute la nuit à guetter la bête.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fais toi pousser les couilles.",
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
					if (bro.getLevel() <= 3 || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_122.png[/img]{%beastslayer% le tueur de bêtes arrive.%SPEECH_ON%Ce n\'est pas dangereux, c\'est perturbant. Je vais m\'en occuper.%SPEECH_OFF%Il mâchonne un biscuit sec, grogne, met le biscuit dans sa poche et s\'en va dans le noir tout seul. Un moment plus tard, la silhouette de l\'alp se détache soudainement et disparaît. Quelques minutes plus tard, le tueur revient, avalant les dernières bouchées de son biscuit. Vous demandez pourquoi l\'alp ne s\'est pas beaucoup battu. Le tueur de bêtes rit.%SPEECH_ON%Vous avez dit que %callbrother% est allé vous chercher dans votre tente, non ? Exact. Et où est %callbrother%?%SPEECH_OFF%Le tueur de bêtes indique le feu de camp. Le mercenaire est là. Endormi. Profondément endormi. Le tueur de bêtes se prend un autre biscuit.%SPEECH_ON%Les jeunes alps apprennent encore comment pénétrer dans votre esprit. Ils ne sont pas doués pour cela et attirent souvent l\'attention sur eux en essayant. Ils sont comme des voleurs qui ne peuvent pas crocheter une serrure, alors ils frappent à la porte à la place.%SPEECH_OFF%Quelques hommes l\'écoutent et sont confortés par les défauts apparents de ces créatures par ailleurs horribles.}  ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				_event.m.Beastslayer.improveMood(0.5, "Dispatched of a youngling alp");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() <= 3 && this.Math.rand(1, 100) <= 33 || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.improveMood(1.0, "Emboldened by learning of the weakness of young alps");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%flagellant% le flagellant est au bord du camp en train de se fouetter à vif. Son instrument de purification de l\'âme est truffé de verre brisé et de griffes de chat, attaché avec du cuir rincé à l\'urine et des glands de crin de cheval tordus. Il marche en direction de l\'alp, se cachant à chaque pas.%SPEECH_ON%Ce n\'est pas que je vous craigne, créature de l\'ombre. Ce n\'est pas que vous craigne, ombres de mon esprit. Ce n\'est pas que je vous craigne, esprit de mon corps.%SPEECH_OFF%L\'homme s\'arrête de marcher, mais l\'urgence de sa flagellation augmente et on peut voir les taches de sang clignoter dans la lumière de la lune.%SPEECH_ON%C\'est que je crains sont les anciens dieux que vous n\'êtes pas! Vous n\'êtes qu\'un insecte!%SPEECH_OFF%La silhouette de l\'alp s\'éloigne, hurle, puis s\'enfuit. L\'homme revient et s\'effondre dans le camp. Quelques hommes sont horrifiés, tandis que d\'autres sont stimulés par son courage et sa droiture.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Par les anciens dieux",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local hitpoints = this.Math.rand(1, 3);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Flagellant.getSkills().update();
				local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Flagellant.getName() + " souffre de " + injury.getNameOnly()
					}
				];
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] Hitpoints"
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

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local candidates_beastslayer = [];
		local candidates_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_flagellant.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.Callbrother = candidates[r];
		candidates.remove(r);
		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		if (candidates_flagellant.len() != 0)
		{
			this.m.Flagellant = candidates_flagellant[this.Math.rand(0, candidates_flagellant.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"callbrother",
			this.m.Callbrother.getName()
		]);
		_vars.push([
			"beastslayer",
			this.m.Beastslayer != null ? this.m.Beastslayer.getName() : ""
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant != null ? this.m.Flagellant.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Callbrother = null;
		this.m.Other = null;
		this.m.Beastslayer = null;
		this.m.Flagellant = null;
	}

});

